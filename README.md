# RailwayEmpire - Rest API in Javascript

## About

## Dependencies

To use this API, make sure you have the following dependencies installed:

### Bun

* **Bun** is a hard requirement for this API. You can install it by following the instructions on the [official Bun website](https://bun.sh/).

Once Bun is installed, set up the API by following these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/Lu-Die-Milchkuh/RailwayEmpire-JS.git
    ```

2. Navigate to the cloned repository:

    ```bash
    cd RailwayEmpire-JS
    ```

3. Install the required packages using Bun:

    ```bash
    bun install
    ```
This will pull and install all the necessary packages for the API to function properly. 

### MYSQL
* MariaDB **might** work but it has **not been tested**!

## Setup
1. Create a `.env.local` file in the root of the directory and specifiy the following information:

    ```bash
    HTTP_PORT=8080

    DB_USER="your_database_user"
    DB_PASSWORD="your_password"
    DB_NAME="your_database_name"
    DB_HOST="127.0.0.1"
    DB_PORT=3306
     
    JWT_SECRET="your_secret"
    ```
2. Then start the server:

    ```bash
    bun run dev
    ```

## API Documentation
For a more detailed documentation visit: https://app.swaggerhub.com/apis/ZEBLU735_1/RailwayEmpire/1.0.0
Alternative: Visit http://<IP>:<PORT>/swagger

## License

    MIT License
 
    Copyright (c) 2023 Lucas Zebrowsky
 
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
 
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
 
