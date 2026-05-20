# More Depth on the Bedrock Converse API

The Converse API in Bedrock comes up a lot. Really, you just need to know that it is the swiss army knife for message-based interactions with foundation models with Bedrock. It provides a consistent API for your models, so you can switch them out in your application more easily.

At a minimum, you need to specific a prompt (which may be a reference to a stored prompt in Bedrock Prompt Management... we're getting there) and a modelId. But there is a bunch of other stuff you can pass in optionally as well.

If you are doing agentic AI stuff, the parameters required for the set of tools used may be passed in via the toolConfig parameters.

You may also pass in guardrail configuration as part of the Converse API. Again, we're getting there - but Guardrails are a way to filter out objectionable inputs and outputs.

Any model-specific information may also be passed through, as well as configuration settings.

The details are likely to change quickly, so I'll refer you to the latest documentation for specific Converse API details and examples of its use. The exam will never expect you to write code, but it is useful to understand how it works.

Here's the current structure of Converse:

```json 
POST /model/modelId/converse HTTP/1.1
Content-type: application/json
 
{
   "additionalModelRequestFields": JSON value,
   "additionalModelResponseFieldPaths": [ "string" ],
   "guardrailConfig": { 
      "guardrailIdentifier": "string",
      "guardrailVersion": "string",
      "trace": "string"
   },
   "inferenceConfig": { 
      "maxTokens": number,
      "stopSequences": [ "string" ],
      "temperature": number,
      "topP": number
   },
   "messages": [ 
      { 
         "content": [ 
            { ... }
         ],
         "role": "string"
      }
   ],
   "outputConfig": { 
      "textFormat": { 
         "structure": { ... },
         "type": "string"
      }
   },
   "performanceConfig": { 
      "latency": "string"
   },
   "promptVariables": { 
      "string" : { ... }
   },
   "requestMetadata": { 
      "string" : "string" 
   },
   "serviceTier": { 
      "type": "string"
   },
   "system": [ 
      { ... }
   ],
   "toolConfig": { 
      "toolChoice": { ... },
      "tools": [ 
         { ... }
      ]
   }
}
```