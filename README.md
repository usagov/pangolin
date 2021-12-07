Pangolin
========

The home for work towards a TTS Future Public Service

Important Links
---------------

* [Wiki](https://github.com/usagov/pangolin/wiki)
* [Google Drive](https://drive.google.com/drive/folders/1F7aUUqleuRVMaKAuOkqf9GXr5eCz-1QH?usp=sharing)

Development
-----------

### Setup

The following prerequisites must be installed

* Ruby 3.0.2
* Node 14.18.1
* PostgreSQL 12+

#### Dependency Install

Run the following commands to install dependencies:

* `bundle install`
* `yarn install`

#### Database Setup

`bundle exec rake db:setup`

### Running Tests

Running tests and static scans:
* Unit and system tests: `bundle exec rake spec`
* Ruby static security scan: `bundle exec rake brakeman`
* Ruby dependency checks: `bundle exec rake bundler:audit`
* JS dependency checks: `bundle exec rake yarn:audit`

Run all of the above: `bundle exec rake`

#### Pa11y Accessibility Scan

`./bin/pa11y-scan`

#### OWASP ZAP Dynamic Security Scan

`./bin/owasp-scan`

### Running the Server

`bundle exec rails server` will start a server listening on port `3000`
