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
        command: "DEBUG=* node ./bin/src/server.js"
        stdout: true
        stderr: true
      codo:
        command: "./node_modules/.bin/codo"
        stdout: true
        stderr: true

    mochacli:
      options:
        reporter: 'spec'
      unit: ['test/unit/**/*.coffee']
      perf: ['test/perf/**/*.coffee']

    watch:
      tdd:
        files: ['test/unit/**/*.coffee', 'test/perf/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test'
      unit:
        files: ['test/unit/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test:unit'
      perf:
        files: ['test/perf/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test:perf'
      docs:
        files: ['README.md', 'src/**/*.coffee']
        tasks: 'doc_generate'

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

  grunt.registerTask('doc_generate', ['exec:codo'])
  grunt.registerTask('docs', ['doc_generate', 'connect:server:keepalive'])

  grunt.registerTask('prepublish', ['clean', 'coffee:compile', 'doc_generate'])

  grunt.registerTask('start', ['coffee:compile', 'exec:start_service'])
  grunt.registerTask('restart', ['clean', 'coffee:compile', 'exec:start_service'])
