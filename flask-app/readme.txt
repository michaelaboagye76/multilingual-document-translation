It’s the frontend interface for your  document translation pipeline 
(Upload → Translate → Download).

This Flask app provides a simple web UI to:

Upload documents → stores them in the input S3 bucket.

List available translations → fetches from the output S3 bucket.

Download translations securely → generates presigned S3 URLs (valid for 1 hour).
