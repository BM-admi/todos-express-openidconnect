var express = require("express");
var passport = require("passport");
var OpenIDConnectStrategy = require("passport-openidconnect");

const baseUri = `${process.env.OIDC_BASE_URI}/oidc/2`;

passport.use(
  new OpenIDConnectStrategy(
    {
      issuer: baseUri,
      clientID: process.env["CLIENT_ID"],
      clientSecret: process.env["CLIENT_SECRET"],
      authorizationURL: `${baseUri}/auth`,
      tokenURL: `${baseUri}/token`,
      userInfoURL: `${baseUri}/me`,
      callbackURL: "/oauth/callback", // should be regestered in redirect URIs listbox
      scope: ["profile"],
    },
    function verify(issuer, profile, cb) {
      console.log("issuer:", issuer);
      console.log("profile:", profile);
      console.log("cb:", cb);
      return cb(null, profile);
    }
  )
);

passport.serializeUser(function (user, cb) {
  process.nextTick(function () {
    cb(null, { id: user.id, username: user.username, name: user.displayName });
  });
});

passport.deserializeUser(function (user, cb) {
  process.nextTick(function () {
    return cb(null, user);
  });
});

var router = express.Router();

router.get("/login", passport.authenticate("openidconnect"));

router.get(
  "/oauth/callback",
  passport.authenticate("openidconnect", {
    successReturnToOrRedirect: "/",
    failureRedirect: "/login",
  })
);

router.post("/logout", function (req, res, next) {
  req.logout(function (err) {
    if (err) {
      return next(err);
    }
    res.redirect("/");
  });
});

module.exports = router;
