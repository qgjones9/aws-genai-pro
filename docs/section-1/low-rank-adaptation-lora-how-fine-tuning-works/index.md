# Low-Rank Adaptation (LoRA) - How Fine-Tuning Works

## How fine-tuning works under the hood

Talk a little bit more in detail about how fine tuning works under the hood. So a popular approach is something called LoRA or low rank adaptation. It's been around for a while.

## LoRA vs retraining the full model

So rather than retrain the entire model from the ground up whenever you have the information to fine tune it on, it's much more efficient to just kind of slap some extra information onto the side of the model. What do we mean by that?

## Low rank matrices at the attention layer

So we're gonna add some what we call low rank matrices to the model at the attention layer usually. That probably doesn't mean anything to you, so let me explain that real quick.

## Self-attention and context

So self-attention is kind of the breakthrough that made large language models take off a few years ago. And there was this paper from Google called Attention is All You Need. At a very high level, the way it works is that there's this layer of these large language models down toward the bottom that understands how the different words in your sentences or your phrases relate to each other, and that's how it understands the context between those words and what you're trying to do.

## Fine-tuning the attention layer

So that is kind of the heart of how this all works, and by just adding a little bit more extra information to, has some extra training on that layer, it turns out we can do a pretty good job of expanding these existing models and fine-tuning them for more specific applications. Now, we might be tackling this on the other parts of the model as well, just the attention weights is the most interesting part. Okay?

## Low rank complexity

Now, I'm not gonna get into the math of how this, all this works, because the exam certainly doesn't expect you to know that, but by low rank, we're just referring to the complexity of these extra matrices that we're slapping onto the side of the model. Right.

## Inference-time weight combination

Now, at inference time, after we've actually trained these new matrices that we've added into our underlying model through fine-tuning, all we have to do is add these fine-tuned weights that are off on the side into the base model, and that's what this little diagram on the side is illustrating here. So we have base input coming into our model at inference time, we have the pre-trained weights from the base model, we also have our fine-tuned weights on the side there, all we gotta do is add them together before we actually start generating the output, okay?

## Storage, training, and inference efficiency

So very efficient way of going about it. The base model itself has remained unchanged, we've just kind of tacked on some extra information onto the side that's used at, at inference time. So obviously this is gonna be a lot more efficient in terms of storage, training, and inference. We don't have to go back and rebuild an entire large language model from scratch, 'cause those things are huge, right? You don't wanna be paying for that. We can just pay for these extra bits of training that we're kind of slapping onto the side there.

## LoRA vs adapter layers (side vs top)

And the important distinction here is that I'm slapping them onto the side and not onto the top, alright? So that's a different way of doing fine-tuning. Another approach is called an, an adapter layer, where instead of like having These extra matrices that are kind of alongside these different layers of the model, we just slap another layer on top where we're kind of embedding all of our fine-tuned information as sort of an afterthought after the whole thing. That works too, LoRA tends to work better, okay?

## LoRA summary

So that's low rank adaptation or LoRA for short, a mechanism for fine-tuning a foundation model without discarding the whole foundation model altogether.
