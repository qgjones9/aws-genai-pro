# Bedrock Guardrails Automated Reasoning Checks

## Automated reasoning checks overview

Another interesting feature in guardrails is automated reasoning checks, and it's more than what it sounds. When you hear "reasoning" in the context of GenAI, sometimes you just think about chain of thought prompts and things like that, but there's more to it here.

## Enforcing complex policies

The idea here is to enforce complex policies you might have around how your application works and enforcing that in the guardrail stage here. So, so maybe it's stuff like a mortgage approval or medical information, stuff like that, where you might have some complex policies that really need to be enforced. And this can help to detect hallucinations in complex scenarios like that.

## Parental leave policy example

So looking at this diagram on the right here as an example, let's say you have a policy that says full-time employees who have worked for at least one year are eligible for parental leave.

The Bedrock Guardrail automated reasoning check would break that down into this set of logic here where we actually extract variables. For example, a boolean that indicates whether or not the employee is full-time or not. If so, it can then check the years of service that it extracted from that employee's records, check if that's greater or equal to one year. If not, then they're not eligible for parental leave. If they are, then they are, and there's the output variable there of eligible for parental leave that was just created automatically along the way. That's a boolean value set to true.

## PDF policies and logic diagrams

So what automated reasoning checks does is take your policies just as a plain text and breaks it down into these logical diagrams that it uses to enforce at the guardrail stage. You provide that policy as just a PDF file, and you just have to make sure it's clear and well organized and well structured so it can work as best as it can.

## Create automated reasoning policy API

The only API here is create automated reasoning policy, where you basically give that policy a name and attach the PDF to it, and that's all there is to it. Bedrock will then try to break out your policy from that file and construct these structured rules and logic that you can see on the right here as an example that can then be applied to the guardrail stage.

## Start simple and iterate

AWS recommends starting simple and working your way up in complexity to make sure that the guardrail is working as you intended. Obviously, there are opportunities for things to go wrong if it interprets your document incorrectly, so start simple and work your way up.
