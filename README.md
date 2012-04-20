# jampel - a ruby app to control a traffic light based on the build status of a jenkins server

## Configuration
Copy the `config.example.json` file with your jenkins settings to `~/.jampel_config.json`.

If you configure more than one Jenkins project, all projects needs to be successfull to switch the traffic light to green

## Run
Install all dependecies with bundler and run the app with `bundle exec thor server:start`. 
