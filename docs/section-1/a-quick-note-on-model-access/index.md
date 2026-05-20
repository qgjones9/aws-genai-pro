# A quick note on model access

Next: [Hands-On with the Bedrock Playground](../hands-on-with-the-bedrock-playground/index.md)


Using Anthropic Models

Access to all Bedrock foundation models is now supposed to be enabled by default, but apparently an exception (for now) is models from Anthropic, like the one we show in the following activity. If you are using an Anthropic model for the first time (like Claude Opus) you need to first submit a use case and request access to it.

You should be able to do this by visiting the Model Catalog in the Bedrock console before using a Claude model. A use case of "educational use with an online course" sounds reasonable to me.

Or, you could simply choose a foundation model that is not from Anthropic.

No Free Tier

Bedrock and many of the newer services covered in this course are not available under the AWS "free tier." You will need a paid account in order to follow along hands-on, and doing so will involve a few dollars in cost. Be sure you have a billing alarm set up to be safe. Of course, you can just watch the videos instead of following along for free.

Quota Limits

Some students are experiencing on-demand quotas for Bedrock being set to zero in their accounts. If you see an error like "Throttling Exception Too many tokens per day, please wait before trying again", you may need to contact AWS support and ask for your quota limit to be increased to a non-zero value. Remember to set up billing alarms and monitor your usage to keep costs under control.