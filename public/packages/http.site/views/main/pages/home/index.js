// Generated by CoffeeScript 1.6.3
var HomeView, mojo, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

mojo = require("mojojs");

HomeView = (function(_super) {
  __extends(HomeView, _super);

  function HomeView() {
    _ref = HomeView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  HomeView.prototype.downloadLink = "https://github.com/classdojo/mojo-starter/archive/master.zip";

  HomeView.prototype.paper = require("./index.pc");

  return HomeView;

})(mojo.View);

module.exports = HomeView;

