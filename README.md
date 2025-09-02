# AWS Serverless Document Translation Pipeline

This project implements a **serverless multilingual translation pipeline** on AWS.
It accepts **JSON documents** containing text blocks and language metadata, translates them into multiple target languages using **Amazon Translate**, and stores the translated results in S3.

The project is deployed using **Terraform / CloudFormation** for Infrastructure-as-Code.

---

## Features

* Upload **JSON files** describing text blocks and target languages.
* Automatic translation using **AWS Lambda + Amazon Translate**.
* Store translated results as **JSON** in an output S3 bucket.
* Web UI (Flask app on EC2) to:

  * Upload input JSON files.
  * List available translated JSON results.
  * Download translations via presigned S3 URLs.
* Infrastructure defined using **Terraform** or **CloudFormation**.

---

## Example Input JSON

Upload this file to the **input bucket** (via Flask app or S3 console):

```json
{
  "source_lang": "en",
  "target_langs": ["fr", "es", "de"],
  "text_blocks": [
    "Hello world",
    "This is AWS Translate",
    "Lambda makes serverless easy"
  ]
}
```

---

## Example Output JSON

Lambda will generate this and store it in the **output bucket**:

```json
{
  "source_lang": "en",
  "translations": {
    "fr": [
      "Bonjour le monde",
      "Ceci est AWS Translate",
      "Lambda facilite le sans serveur"
    ],
    "es": [
      "Hola mundo",
      "Esto es AWS Translate",
      "Lambda facilita el serverless"
    ],
    "de": [
      "Hallo Welt",
      "Dies ist AWS Translate",
      "Lambda macht serverlos einfach"
    ]
  }
}
```

---

## Architecture

1. **Flask App (EC2)** → Upload JSON → stored in **S3 Input Bucket**.
2. **S3 Event** → triggers **Lambda**.
3. **Lambda** → reads JSON, calls **Amazon Translate**, generates new JSON.
4. **Lambda** → saves results to **S3 Output Bucket**.
5. **Flask App** → Lists available translations + download links.

---

## Technologies Used

* **AWS Lambda** – JSON processing + translation.
* **Amazon S3** – Input/output storage.
* **Amazon Translate** – Multilingual translation.
* **IAM** – Secure roles/policies.
* **Flask (Python)** – Web UI for uploads/downloads.
* **Terraform** – Infrastructure as Code.
* **Boto3** – AWS SDK for Python (S3 + Translate).

---

## Deployment Steps

### **Using Terraform for IaC**

1. Zip Lambda code automatically (`archive_file`).
2. Run:

   ```bash
   terraform init
   terraform apply
   ```


## Future Enhancements

* Add support for multiple input formats (CSV, TXT).
* Add authentication for Flask UI (Cognito or IAM).
* Store translation history in DynamoDB.
* Add CI/CD pipeline (CodePipeline + CodeBuild).
