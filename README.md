# Rails ActiveJob Async Test w/rake

I've been having issues consistently performing active_job's in :async mode. In :inline mode, it seems to work perfectly fine. I wanted to make sure there wasn't an issue with namespaced classes causing issues (because sometimes it can be a little finicky), which is why I have 2 sets of classes.

It works fine with :sidekiq and :resque, which leads me to believe that it's an issue with :async somewhere, with rake closing the connection and flushing the memory.

### Rake

`rake run_both` && `rake run_tumby` && `rake run_nested` all call the respective classes `#build_integer`.

### Class Methods

`Nested::Testy.build_integer` & `Tumby.build_integer` both are model methods that instantiate job enqueuing.

### Jobs

`Nested::TestyJob` & `TumbyJob` are both ActiveJobs that call the respective classes `#do_this`

### #do_this

`#do_this` runs a print, a log insert, and a database insert.

## Expectations

1. I would expect `rake run_both` to properly run both `Nested::Testy.build_integer` & `Tumby.build_integer`.
2. I would expect `Nested::Testy.build_integer` & `Tumby.build_integer` to run their respective jobs
3. I would expect `TumbyJob.perform` & `Nested::TestyJob.perform` to run their respective classes `#do_this`
4. I would expect `Tumby.do_this` & `Nested::Testy.do_this` to print the int 5, log it, and insert a record with num: 5
 
## Actuality

When I run the rake tasks in a console session through `.invoke`, the rake task runs, 1-4 happen.
When I run the rake tasks in the command line, more often than not, the first task runs asyncronously, completes, and the second one starts up asyncronously, and then as all task have been run in the main thread. Based on the output you see here.

```
task run_both_model: :environment do
  p "both models before tumby"
  Tumby.build_integer
  p "both models after tumby"
  p "both models before testy"
  Nested::Testy.build_integer
  p "both models after testy"
end
```
gives us...
```
"both models before tumby"
"Tumby build integer"
"both models after tumby"
TumbyJob"
"Tumby do_this"
"int: 5"

"both models before testy"
"Nested::Testy build integer"
"both models after testy"
```
As you can see, the rake task stops after it reaches the end, even though there's threads happening still, it halts the execution, and the second `build_integer` task never gets run. It's a race condition to finish before the rake main execution finishes, which, given what most Jobs are used for, will never happen.

The docs say `:async` is good for dev/test, and for open servers, yes, but for running tasks as jobs, it doesn't work. This is a pretty common build pattern.
