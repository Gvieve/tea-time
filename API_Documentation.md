# Tea Time API Documentation

## Endpoints
| HTTP verbs | Paths  | Used for | Output |
| ---------- | ------ | -------- | ------:|
| POST | /api/v1/users | Create a new user | [json](#create-user) |
| POST | /api/v1/users/:user_id/subscriptions | Create a new user subscription for one or more teas | [json](#create-user-subscription) |
| PATCH | /api/v1/users/:user_id/subscriptions/:id | Update a user's subscription and/or related tea subscriptions | [json](#update-user-subscription) |
| GET | /api/v1/users/:user_id/subscriptions | Get all of the subscriptions for a user | [json](#user-subscriptions) |
| GET | /api/v1/teas | Get all available teas | [json](#all-teas) |
| GET | /api/v1/users/:user_id/tea_subscriptions?<param> | Find all active user tea subscriptions based on brew_time or temperature | [json](#all-teas) |
| ERROR | errors | Error handling for requests | [json](#error-handling) |

### Create User
`POST /api/v1/users`

The request creates a user record and related user profile when given valid data.
* __Required__

  The following fields are required in the post body request. If any required fields are missing or include invalid data an error will be returned (see [error handling](#error-handling)).
  * email = string (must be a valid email format)
  * first_name = string
  * last_name = string
  * street_address = string
  * city = string
  * state = string
  * zipcode = string

  Example json request body
  ```json
  {
    "email": "email@email.com",
    "first_name": "Cindy Lou",
    "last_name": "Who",
    "street_address": "123 Cool St",
    "city": "Whoville",
    "state": "CO",
    "zipcode": "80210"
  }
  ```

  Example json response
  ```json
  {
    "data": {
      "id": "1",
      "type": "user",
      "attributes": {
        "email": "email@email.com",
        "first_name": "Cindy Lou",
        "last_name": "Who",
        "street_address": "123 Cool St",
        "city": "Whoville",
        "state": "CO",
        "zipcode": "80210"
      }
    }
  }
  ```

### Create User Subscription
`POST /api/v1/users/:user_id/subscriptions`

The request creates a user subscription record and one or more tea subscription records when given valid data.
* __Required__

  The following fields are required in the route and post body request. If any required fields are missing or include invalid data an error will be returned (see [error handling](#error-handling)).
  * user_id = integer
  * process_on_date = string (in date format YYYY-MM-DD)
  * weekly_frequency = integer (whole number value between 1-12)
  * teas = Array (must include at least __one__ tea record, and each record must have the below data)
      * tea_id = integer
      * quantity = integer

* __Optional__

  The following fields are optional, if not provided they will be stored as null
  * name = string

  Example json request body
  `POST /api/v1/users/1/subscriptions`
  ```json
  {
    "name": "My Monthly Tea Fix",
    "process_on_date": "2021-07-01",
    "weekly_frequency": 4,
    "teas": [
      {
        "tea_id": 201,
        "quantity": 1
      },
      {
        "tea_id": 254,
        "quantity": 2
      }
    ]
  }
  ```

  Example json response
  ```json
  {
    "data": {
      "id": "12",
      "type": "user_subscription",
      "attributes": {
        "user_id": 1,
        "name": "My Monthly Tea Fix",
        "process_on_date": "2021-07-01",
        "weekly_frequency": "Every 4 weeks",
        "status": "active",
        "teas": [
          {
            "tea_id": 201,
            "title": "Earl Grey",
            "box_count": 20,
            "quantity": 2,
            "unit_price": "7.99",
            "total_price": "15.98",
            "status": "active"
          },
          {
            "tea_id": 254,
            "title": "Lemon Lift",
            "box_count": 20,
            "quantity": 1,
            "unit_price": "16.99",
            "total_price": "16.99",
            "status": "active"
          }
        ]
      }
    }
  }
  ```

### Update User Subscription
`PATCH /api/v1/users/:user_id/subscriptions/:subscription_id`

The request updates an existing user subscription record, and if included adds or updates any related tea subscription records when given valid data. Only the tea subscription records that are included in the request will be updated, existing records related to this subscription that are not included in the request will not be updated.
* __Required__

  The following fields are required in the route and post body request. If any required fields are missing or include invalid data an error will be returned (see [error handling](#error-handling)).
  * user_id = integer
  * subscription_id = integer
  * status = string (only values accepted are active, cancelled, paused)

* __Optional__

  The following fields are optional, if not provided they will be stored as null
  * name = string
  * process_on_date = string (in date format YYYY-MM-DD)
  * weekly_frequency = integer (whole number value between 1-12)
  * teas = Array (if any tea records are included each must have the below data)
      * tea_id = integer
      * quantity = integer
      * status = string (only values accepted are active, cancelled, paused)

  Example json request body
  `PATCH /api/v1/users/1/subscriptions/12`
  ```json
  {
    "status": "active",
    "process_on_date": "2021-07-15",
    "weekly_frequency": 6,
    "teas": [
      {
        "tea_id": 201,
        "quantity": 1,
        "status": "cancelled"
      },
      {
        "tea_id": 254,
        "quantity": 1,
        "status": "active"
      },
      {
        "tea_id": 303,
        "quantity": 1,
        "status": "active"
      }
    ]
  }
  ```

  Example json response
  ```json
  {
    "data": {
      "id": "12",
      "type": "user_subscription",
      "attributes": {
        "user_id": 1,
        "name": "My Monthly Tea Fix",
        "process_on_date": "2021-07-01",
        "weekly_frequency": "Every 4 weeks",
        "status": "active",
        "teas": [
          {
            "tea_id": 201,
            "title": "Earl Grey",
            "box_count": 20,
            "quantity": 2,
            "unit_price": "7.99",
            "total_price": "15.98",
            "status": "active"
          },
          {
            "tea_id": 254,
            "title": "Lemon Lift",
            "box_count": 20,
            "quantity": 1,
            "unit_price": "16.99",
            "total": "16.99",
            "status": "active"
          }
        ]
      }
    }
  }
  ```

### Get User's Subscriptions
`GET /api/v1/users/:user_id/subscriptions`

The request gets all user subscription records and related tea subscription records when given valid data.
* __Required__

  The following fields are required in the route request. If any required fields are missing or include invalid data an error will be returned (see [error handling](#error-handling)).
  * user_id = integer

  Example json response
  `GET /api/v1/users/1/subscriptions`
  ```json
  {
    "data": {
      "id": "12",
      "type": "user_subscriptions",
      "attributes": {
        "subscriptions": [
          {
            "user_id": 1,
            "name": "My Monthly Tea Fix",
            "process_on_date": "2021-07-01",
            "weekly_frequency": "Every 4 weeks",
            "status": "active",
            "teas": [
              {
                "tea_id": 201,
                "title": "Earl Grey",
                "box_count": 20,
                "quantity": 2,
                "unit_price": "7.99",
                "total_price": "15.98",
                "status": "active"
              },
              {
                "tea_id": 254,
                "title": "Lemon Lift",
                "box_count": 20,
                "quantity": 1,
                "unit_price": "16.99",
                "total_price": "16.99",
                "status": "active"
              }
            ]
          },
          {
            "user_id": 1,
            "name": "My Teas",
            "process_on_date": "2020-07-01",
            "weekly_frequency": "Every 4 weeks",
            "status": "cancelled",
            "teas": [
              {
                "tea_id": 201,
                "title": "Earl Grey",
                "box_count": 20,
                "quantity": 3,
                "unit_price": "7.99",
                "total_price": "23.97",
                "status": "cancelled"
              }
            ]
          }
        ]
      }
    }
  }
  ```
### Find User Tea Subscriptions by Brew Temp or Time

`GET /api/v1/users/:user_id/tea_subscriptions?min_brew_temp=<value>&max_brew_time=<value>`

The request finds all active unique user tea subscriptions records. You may optionally search with query parameters of brew_temp or brew_time, both can be searched by min or max values. Results are ordered by tea title.
* __Required__

  The following fields are required in the route request. If any required fields are missing or include invalid data an error will be returned (see [error handling](#error-handling)).
  * user_id = integer

* __Optional__

  You may include the following query parameters. You may search by both brew_temp and brew_time together, but min and max of the same type cannot be included. If no query parameters are included, all active unique tea subscriptions are returned.
  * min_brew_temp = integer (must be 0 or greater)
  * max_brew_temp = integer (must be 0 or greater)
  * min_brew_time = integer (must be 0 or greater)
  * max_brew_time = integer (must be 0 or greater)

  Valid examples:
  * `/api/v1/users/1/tea_subscriptions`
  * `/api/v1/users/1/tea_subscriptions?min_brew_temp=190`
  * `/api/v1/users/1/tea_subscriptions?max_brew_time=9`
  * `/api/v1/users/1/tea_subscriptions?min_brew_temp=190&max_brew_time=9`

  Invalid examples that will result in an error:
  * `/api/v1/users/1/tea_subscriptions?min_brew_temp=190&max_brew_temp=100`
  * `/api/v1/users/1/tea_subscriptions?min_brew_temp=-1`

  Example json response
  `/api/v1/users/1/tea_subscriptions?min_brew_temp=190&max_brew_time=9`
  ```json
  {
    "data": {
      "id": "1",
      "type": "user_tea_subscriptions",
      "attributes": {
        "tea_subscriptions": [
          {
            "id": 201,
            "title": "Earl Grey",
            "description": "English classic black tea.",
            "brew_temp": 195,
            "brew_time": 6,
            "box_count": 20,
            "status": "active"
          },
          {
            "id": 89,
            "title": "Peach Sleepytime",
            "description": "Fruity peach herbal tea to help you go to bed.",
            "brew_temp": 195,
            "brew_time": 7,
            "box_count": 20,
            "status": "active"
          },
          {
            "id": 163,
            "title": "Lemon Lift",
            "description": "Light and citrusy lemon flavored tea",
            "brew_temp": 202,
            "brew_time": 5,
            "box_count": 20,
            "status": "active"
          }
        ]
      }
    }
  }
  ```

### Error Handling
### Sad Path Response (no data matches query)
* A sad path response is returned when no matching data can be found, such as when the tea search returns 0 results.

  ```json
    {
      "data": {}
    }
  ```

### Edge Case Response (invalid data parameters)
* An edge case error is returned when invalid data parameters are provided, such as invalid user/subscription id, missing parameters, or invalid data for a parameter (i.e. empty string, blank, letter instead of integer, etc.).

  ```json
  {
    "message": "your request cannot be completed",
    "error": "error message",
    "url": "https://www.somedocinfo.com"
  }
  ```
