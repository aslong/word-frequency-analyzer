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

    connect:
      server:
        options:
          port: 9000
          base: 'public'
          open: true

    exec:
      start_service:
        command: "DEBUG=* node ./bin/src/index.js"
        stdout: true
        stderr: true

    mochacli:
      options:
        reporter: 'spec'
      all: ['test/unit/**/*.coffee']

    watch:
      tdd:
        files: ['test/unit/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test'

  grunt.loadNpmTasks('grunt-exec')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-mocha-cli')

  grunt.registerTask('test', ['mochacli'])

  grunt.registerTask('start', "Boot up the word analyzer's web server", () ->
    grunt.task.run('coffee:compile', 'connect:server:keepalive')
  )

  grunt.registerTask('restart', "Boot up the word analyzer's web server", () ->
    grunt.task.run('clean', 'coffee:compile', 'connect:server:keepalive')
  )
