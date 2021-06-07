# Tea Time API

### Created by:
- [Genevieve Nuebel](https://github.com/Gvieve)  |  [LinkedIn](https://www.linkedin.com/in/genevieve-nuebel/)

Tea time provides foundational API endpoints that can be adopted for a basic tea subscription sales platform. It provides a starting point for a useful database schema, which includes sample records for teas, users and subscriptions.
#### Built With
* [Ruby on Rails](https://rubyonrails.org)
* [HTML](https://html.com)

This project was tested with:
* RSpec version 3.10

## Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
- [Database Design](#database-design)
- [Endpoints](#endpoints)
- [Testing](#testing)
- [How to Contribute](#how-to-contribute)
- [Roadmap](#roadmap)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)

### Getting Started

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on how to deploy the project on a live system.

#### Prerequisites

* __Ruby__

  - The project is built with rubyonrails using __ruby version 2.5.3p105__, you must install ruby on your local machine first. Please visit the [ruby](https://www.ruby-lang.org/en/documentation/installation/) home page to get set up. _Please ensure you install the version of ruby noted above._

* __Rails__
  ```sh
  gem install rails --version 5.2.6
  ```

* __Postgres database__
  - Visit the [postgresapp](https://postgresapp.com/downloads.html) homepage and follow their instructions to download the latest version of Postgres.app.

#### Installing

1. Clone the repo
  ```
  $ git clone https://github.com/Gvieve/tea-time
  ```

2. Bundle Install
  ```
  $ bundle install
  ```

3. Create, migrate and seed rails database
  ```
  $ rails db:{create,migrate,seed}
  ```

  If you do not wish to use the sample data provided to seed your database, replace the sample data that is generated in `db/seeds.rb` file.

4. Start rails server
  ```
  $ rails s
  ```  

### Database Design
![Database Schema Design Document](https://user-images.githubusercontent.com/72330302/120543523-9e709600-c3a9-11eb-901a-a9a762fc3cdd.png)

### Endpoints

| HTTP verbs | Paths  | Used for | Output |
| ---------- | ------ | -------- | ------:|
| POST | /api/v1/users | Create a new user | [api doc](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#create-user) |
| POST | /api/v1/users/:user_id/subscriptions | Create a new user subscription for one or more teas | [api doc](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#create-user-subscription) |
| PATCH | /api/v1/users/:user_id/subscriptions/:id | Update a user's subscription and/or related tea subscriptions | [api doc](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#update-user-subscription) |
| GET | /api/v1/users/:user_id/subscriptions | Get all of the subscriptions for a user | [api doc](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#user-subscriptions) |
| GET | /api/v1/teas | Get all available teas | [api doc](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#all-teas) |
| GET | /api/v1/users/:user_id/tea_subscriptions?<param> | Find all active user tea subscriptions based on brew_time or temperature | [json](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#all-teas) |
| ERROR | errors | Error handling for requests | [api doc](https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md#error-handling) |

### Testing
##### Running Tests
- To run the full test suite run the below in your terminal:
```
$ bundle exec rspec
```
- To run an individual test file run the below in tour terminal:
```
$ bundle exec rspec <file path>
```
for example: `bundle exec rspec spec/requests/users/create_user_spec.rb`

### How to Contribute

In the spirit of collaboration, things done together are better than done on our own. If you have any amazing ideas or contributions on how we can improve this API they are **greatly appreciated**. To contribute:

  1. Fork the Project
  2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
  3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
  4. Push to the Branch (`git push origin feature/AmazingFeature`)
  5. Open a Pull Request

### Roadmap

See the [open issues](https://github.com/Gvieve/tea-time) for a list of proposed features (and known issues). Please open an issue ticket if you see an existing error or bug.


### Contributors
- [Genevieve Nuebel](https://github.com/Gvieve)

  See also the list of
  [contributors](https://github.com/Gvieve/tea-time/graphs/contributors)
  who participated in this project.

### Acknowledgments
  - My amazing and always supportive 2011 cohort peers at the [Turing School of Software and Design](https://turing.edu/):
  - Our fantastically wizard like instructors at [Turing School of Software and Design](https://turing.edu/):
    * Bob Gu
    * Dione Wilson
    * Travis Rollins
