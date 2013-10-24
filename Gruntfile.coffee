module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      build: 'bin/'

    coffee:
      compile:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'bin/src/'
        ext: '.js'

    connect:
      server:
        options:
          port: 4000
          base: 'docs'
          debug: true
          hostname: '*'

    exec:
      start_service:
        command: "DEBUG=* node ./bin/src/index.js"
        stdout: true
        stderr: true

    mochacli:
      options:
        reporter: 'spec'
      unit: ['test/unit/**/*.coffee']
      perf: ['test/perf/**/*.coffee']

    watch:
      tdd:
        files: ['test/unit/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test:unit'
      perf:
        files: ['test/perf/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test:perf'

    yuidoc:
      compile:
        name: '<%= pkg.name %>'
        description: '<%= pkg.description %>'
        version: '<%= pkg.version %>'
        url: '<%= pkg.homepage %>'
        options:
          paths: 'src/'
          outdir: 'docs'
          extension: '.coffee'
          syntaxtype: 'coffee'

  grunt.loadNpmTasks('grunt-exec')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-mocha-cli')
  grunt.loadNpmTasks('grunt-contrib-yuidoc')

  grunt.registerTask('test', ['mochacli'])
  grunt.registerTask('test:unit', ['mochacli:unit'])
  grunt.registerTask('test:perf', ['mochacli:perf'])
  grunt.registerTask('docs', ['yuidoc', 'connect:server:keepalive'])

  grunt.registerTask('start', "Boot up the word analyzer's web server", () ->
    grunt.task.run('coffee:compile', 'exec:start_service')
  )

  grunt.registerTask('restart', "Clean and Boot up the word analyzer's web server", () ->
    grunt.task.run('clean', 'coffee:compile', 'exec:start_service')
  )
