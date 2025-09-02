# Multilingual Document Translation & Storage System

## Overview

This project is a **serverless document translation pipeline** built on AWS. Users upload documents (TXT, DOCX, PDF) to an **S3 bucket**, which triggers a **Lambda function** to:

1. Extract the text content.
2. Call **AWS Translate** to generate translations in multiple languages.
3. Store the translated documents in a structured **output S3 bucket**.

An optional **Flask app on EC2** provides a simple web UI for uploading documents and downloading translated files.


Architecture Diagram
---

![Architecture Diagram](doc/architecture-diagram.png)



---

## Tools & Services
* **AWS S3** → document storage (input + output).
* **AWS Lambda** → serverless text extraction & translation.
* **AWS Translate API** → multilingual text translation.
* **Python (Boto3, python-docx, PyPDF2)** → document parsing & AWS SDK integration.
* **Terraform** → infrastructure provisioning (S3, Lambda, IAM).
* **CloudFormation** → IAM policies for Lambda execution role.
* **IAM** → fine-grained access control.
* **EC2 + Flask (optional)** → user-friendly document upload & download portal.

---

## S3 Folder Structure

```
doc-uploads/
   resume.docx
   report.pdf

doc-translated/
   fr/resume.txt
   es/resume.txt
   de/resume.txt
```

---
---
## Deployment Steps

### **1. Infrastructure Setup**

Provision resources with Terraform:

* Input bucket (`doc-uploads`)
* Output bucket (`doc-translated`)
* Lambda function + IAM role

Example:

```bash
terraform init
terraform apply
```

Deploy IAM policies with CloudFormation:

```bash
aws cloudformation deploy --template-file iam.yaml --stack-name translate-stack
```

---

### **2. Lambda Function**

* Trigger: **S3 Upload event** from `doc-uploads`.
* Role: Allows `s3:GetObject`, `s3:PutObject`, and `translate:TranslateText`.
* Runtime: Python 3.11.

Python dependencies:

```bash
pip install boto3 python-docx PyPDF2
```

---

### **3. Workflow**

1. Upload a document into `doc-uploads`.
2. Lambda extracts text + translates into French, Spanish, and German.
3. Translated documents appear in `doc-translated/{lang}/`.
4. (Optional) Use Flask app on EC2 to upload/download documents.

---

## Optional Flask App

* EC2 instance running Flask/Django.
* Features:

  * Upload documents (stored in `doc-uploads`).
  * List/download translated files from `doc-translated`.
* Uses **Boto3 + presigned URLs** for secure access.

---

## Security (IAM Best Practices)

* Lambda role uses **least privilege** (only S3 + Translate permissions).
* EC2 instance role is **read-only** for output bucket.
* Buckets use **block public access** (no public uploads).

---


## Future Enhancements

* Add **API Gateway** to expose translation as an API.
* Support more formats (HTML, Markdown).
* Store metadata in **DynamoDB** for tracking jobs.
* Use **Step Functions** for better orchestration.

---

## Author

Michael Aboagye (End-to-End Cloud Project)

---



