module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      build: 'bin/'

    coffee:
      compile:
        expand: true
        flatten: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'bin/src/'
        ext: '.js'


    mochacli:
      options:
        reporter: 'spec'
      all: ['test/unit/**/*.coffee']

    watch:
      tdd:
        files: ['test/unit/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test'

  grunt.registerTask('test', ['mochacli'])
  grunt.loadNpmTasks('grunt-mocha-cli')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.registerTask('default', "Boot up the word analyzer's web server", () ->
    grunt.log.write("Starting the word analyzer's web server").ok()
  )
