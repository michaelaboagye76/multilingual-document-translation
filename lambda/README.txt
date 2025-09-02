    
lambda function operation steps

Trigger: S3 -> JSON file upload
    Workflow:
      1. Download JSON file from input bucket
      2. Parse metadata: source_lang, target_langs, text_blocks
      3. Call AWS Translate on each text block
      4. Save translations into new JSON
      5. Upload result JSON to output bucket
      
      
-------------------------------------------------------------------    
 summary
 
 This Lambda code now:

Accepts JSON input with metadata.

Submits text blocks to Translate.

Saves results into new JSON.

Uploads to response bucket.
    
