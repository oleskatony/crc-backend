# Cloud Resume Challenge Back-End
Welcome to the back-end repository of the Cloud Resume Challenge project! This repository contains all the files and components related to the back-end implementation of the challenge. If you're interested in exploring the Terraform configuration, Lambda function, and GitHub Actions that controll deployment of all the infrastructure, you're in the right place. If you would like to learn more about the project, please check out the [front-end repository.](https://github.com/oleskatony/cloudresumechallenge)

To view the finished project, you can view my website [here!](https://antoleska.net) 

![Website](https://img.shields.io/website?down_color=red&down_message=offline&label=antoleska.net&style=plastic&up_color=green&up_message=online&url=https%3A%2F%2Fantoleska.net)

# Back-End Components
The back-end components play a crucial role in this project, enabling the visitor counter functionality and handling the interactions between the front-end and database. Here's an overview of each component:

## API Gateway
An API Gateway is set up to receive requests from the front-end and forward them to the Lambda function. It acts as a bridge between the front-end and back-end components, handling incoming requests and routing them to the appropriate back-end service. There is a script in the front-end that automaticly sends a post request to the API Gateway, which then triggers the Lambda function.

## Lambda Function
The Lambda function is the heart of the back-end implementation. Written in Python, it is executed in a serverless environment. The function is responsible for updating the visitor count stored in DynamoDB and returning a response to the API Gateway. When invoked, the Lambda function retrieves the current visitor count from DynamoDB, increments it, updates the count in DynamoDB, and sends a response back to the API Gateway.

## DynamoDB
DynamoDB serves as the database for storing the visitor count. It provides a scalable, NoSQL data storage solution. The visitor count is stored in a DynamoDB table, and the Lambda function interacts with this table to read and update the count.

## Infrastructure as Code (IaC)
To streamline the creation of serverless components, this project utilizes Terraform, an Infrastructure as Code (IaC) tool. Terraform allows for the declarative definition and provisioning of infrastructure resources, enabling efficient and consistent deployment of the API Gateway, Lambda function, and DynamoDB. The Terraform configuration files in this repository define the desired infrastructure state.

## Continuous Integration and Continuous Deployment (CI/CD)
For managing changes to the codebase and automating deployments, this project integrates GitHub Actions and the AWS Command Line Interface (CLI). GitHub serves as the version control system, facilitating code management. Much like the front-end, GitHub Actions are used to enact AWS CLI commands, Terraform commands, and Python (pytest) to test and deploy changes made to the codebase to the AWS infrastructure. This ensures a streamlined CI/CD process.

# Conclusion
By successfully implementing this project, the backend repository establishes a powerful serverless architecture for the static website. Leveraging AWS services such as API Gateway, Lambda, and DynamoDB, the backend seamlessly integrates the visitor counter functionality. The serverless approach offers several benefits, including automatic scaling, reduced operational overhead, and cost efficiency. With serverless solutions, the backend components dynamically scale based on demand, ensuring optimal performance during high traffic periods. Additionally, the use of AWS Lambda enables efficient execution of code in a serverless environment, eliminating the need to manage infrastructure. DynamoDB provides a scalable NoSQL data storage solution, ensuring reliable and efficient management of the visitor count. Overall, the adoption of serverless solutions in the backend optimizes resource utilization, simplifies maintenance, and enhances the scalability and cost-effectiveness of the project.