var gulp = require('gulp');
var connect = require('gulp-connect');
var zip = require('gulp-zip');
var minifyCss = require('gulp-minify-css');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var forceDeploy = require('gulp-jsforce-deploy');

gulp.task('webserver', function() {
  connect.server({
  	livereload: true
  });
});

gulp.task('zip-vendor', function () {
        return gulp.src('bower_components/**/*.*')
                .pipe(gulp.dest('build/vendor'));
});

gulp.task('css', function() {
	return gulp.src('src/css/*.css')
		.pipe(minifyCss({compatibility: 'ie8'}))
                .pipe(gulp.dest('build/css'));
});

gulp.task('js', function() {
	return gulp.src('src/js/*.js')
    	        .pipe(uglify())
                .pipe(gulp.dest('build/js'));
});

gulp.task("statics", function() {
  return gulp.src(["./src/**/*.html", "./src/img/**/*"], {
    base: "./src"
  }).pipe(gulp.dest("build"));
});

gulp.task("zip", ["css", "js", "statics"], function() {
  return gulp.src("build/**/*").pipe(zip("MyApp.resource")).pipe(gulp.dest("pkg/staticresources"));
});

gulp.task("forceDeploy", function() {
    return gulp.src("./pkg/**/*", {
      base: "."
    }).pipe(zip("pkg.zip")).pipe(forceDeploy({
      username: process.env.SF_USERNAME,
      password: process.env.SF_PASSWORD,
      loginUrl: "https://test.salesforce.com"
    }));
  });

gulp.task('watch', ['webserver']);
gulp.task('build', ['zip']);
gulp.task('deploy', ['build','forceDeploy']);
