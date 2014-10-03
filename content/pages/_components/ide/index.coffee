views = require "mojo-views"
superagent = require "superagent"
compiler = require "./compiler"
bindableCall = require "bindable-call"
bindable = require "bindable"

class IdeView extends views.Base
  bindings:
    "file.files.first": "currentFile"
    "currentFile": () -> 
      return if @_compiledInitially
      @_compiledInitially = true
      @recompile()
    "compileRequest.loading": "loading"
    "compileRequest.result": "script"
    "compileRequest.error": "error"

  paper: require("./index.pc")
  showPreview: true
  children:
    header: require("./header")
    content: require("./content")

  setCurrentFile: (file) ->
    @set "currentFile", file

  prepForRecompile: () ->
    @set "canRecompile", true

  recompile: () ->
    return unless process.browser
    @set "canRecompile", false
    @preview()
    @set "compileRequest", bindableCall (complete) =>
      compiler.compile _flattenFiles(@file), complete


  expand: () ->
    @set "expanded", not @get "expanded"


  editor: () ->
    @set "showPreview", false

  preview: () ->
    @set "showPreview", true
    if @canRecompile
      @recompile()

  addFile: () ->
    fileName = String(prompt("file name:") || "").replace(/^\//, "")
    return unless fileName.length
    fileParts = fileName.split("/")
    fileName = fileParts.pop()
    folder = _findFolder @file, fileParts
    folder.get("files").push currentFile = new bindable.Object {
      name: fileName,
      depth: folder.get("depth") + 1,
      content: ""
    }

    @set "currentFile", currentFile



_findFolder = (folder, path, depth = 1) ->
  cpath = path.shift()
  unless cpath
    return folder

  for file in folder.get("files").source()
    if file.get("name") is cpath
      foundFile = file
      break

  unless foundFile
    folder.get("files").push foundFile = new bindable.Object {
      name: cpath,
      depth: depth,
      files: new bindable.Collection()
    }


  _findFolder foundFile, path, depth + 1




_flattenFiles = (file, dirname = "", files = []) ->
  if file.get("files")
    file.get("files").each (subFile) -> _flattenFiles subFile, dirname + file.get("name"), files
  else
    files.push {
      path: dirname + file.get("name"),
      content: decodeURIComponent(file.get("content"))
    }

  files

module.exports = IdeView