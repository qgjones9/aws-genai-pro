# SageMaker Data Wrangler

## Overview and core capabilities

SageMaker Data Wrangler is probably the most directly applicable technology in SageMaker for data engineering. It's basically an ETL pipeline that's baked into SageMaker Studio, and as you might imagine, it has a lot in common with Glue Data Studio. It's used to prepare data primarily for machine learning though, so it's custom tailored for machine learning pipelines.

It allows you to import data from wherever it might be, maybe it's CSV files in S3 or streaming in, who knows? It allows you to visualize that data and make sure that you're happy with the distribution of that data and know about any outliers that might be happening before you can Go on to push that into your machine learning model, and it can transform your data. They have more than three hundred transformations to choose from from within Data Wrangler, or you can integrate your own transformations using Pandas code or PySpark or PySpark SQL if you want to do something special.

Another cool feature is that it has something called Quick Model, and that allows you to actually train your model that you're trying to prepare the data for with some subset of that data and quickly measure its results. So that allows you to experiment with different transformations and different ways of preparing your data to optimize it for the model you're feeding it into and experiment and figure out what the best transformations are to produce the best results from the model that you're going to be training this data from.

## Architecture and data sources

Block diagram, let's see what that looks like. So basically, SageMaker Data Wrangler sits in the middle here between data sources and where you might send it to. You can see it can take in data from S3, from Lake Formation, from Athena, from SageMaker Feature Store, which we talked about earlier, or from Redshift, or from anything that can talk to JDBC. That would include things like software as a service applications like Salesforce or something, or maybe external systems such as Databricks.

## Code generation and export destinations

Once you've gone through the Data Wrangler pipeline, that can export code in a Jupyter Notebook that can then be used as part of a machine learning notebook to further import and transform and process your data. So it's important to understand that Data Wrangler isn't really doing the transformations of your pipeline itself, it's just generating code to do those transformations in your pipeline. So think of it more as a code generation tool at the end of the day.

That code can then have an endpoint of its own where it dumps this data to, maybe it goes into Amazon SageMaker processing to train a model, maybe it goes to SageMaker pipelines as part of a larger process, or maybe it goes back into SageMaker Feature Store to make these transformed features available to other models.

## Studio demo and importing data

Let's just walk through an example here. So this is what it looks like, this is SageMaker Studio. So if you wanna import data, we start from the Import tab here up top, and in this example, we're taking in this CSV file. So we're specifying a specific file name under a specific S3 bucket with a specific file type, and you can see it's previewing what's in that CSV file automatically just to make sure it's what you expect.

So this is a data set we looked at earlier back in our SQL activities way back when. Same data set here where we have passengers on the Titanic, and dataset tells you who survived, who didn't, what their class was, you know, first class, second class, third class, their name, and other information about them.

## Data preview and column configuration

You can further expand that preview to see what's going on and actually see what the data types are that were inferred for each one, and you can change that if you need to. So if it guessed wrong on the data types, you can change that there. If you want to have more human-readable column names, you can also change that here as well.

## Visualizing data distributions

You can also visualize the data and make sure that the distribution is what you expect. So here we can see the age is following a pretty good distribution. they trended younger than I expected on the Titanic, actually. It's just a sanity check, so this isn't a data analytics course, so I'm not gonna get into this too much, but it allows you to preview the properties of that data and make sure that it's what you expect before you turn around and feed that into a machine learning model.

## Transforming data with one-hot encoding

And then you can transform the data. So in this example here, we're taking the class and one-hot encoding it, so that transformation is called encode categorical. Very common thing to do with machine learning. So typically with machine learning, you know, the inputs have to be these binary ones and zeros. You can't just feed it an arbitrary number typically. So what we're gonna do is instead of passing in one feature for the class, where that might be one, two, or three, we'll have three different features going in that basically says, "Am I in class one? Am I in class two? Or am I in class three? " And one of those three features will be true or one for each individual passenger. So that's what encode_categorical does, but in the machine learning world, we call that one-hot encoding.

Just one example of the transformations you might do, and your choices of how you transform this data and how you present it to your model can make a big difference in the quality of that model. So things like how you normalize that data can also be extremely important as well, or just what data you're giving it and what data you're holding back, right?

## Quick Model

Now, the really cool thing is that you can do what's called a quick model to train your model using that data, using that transformed data, so you can test how well your choices for transformation actually affected the machine learning model down the pipeline here, which is a pretty powerful thing, so I can make sure that my choices for ETL here are going to be optimal for the model that I'm feeding this data into.

## Exporting the data flow

And then when I'm done, I can export that data flow. Again, all this does is create code for you basically. So this is going to output a Jupyter notebook is one output, but basically it's Python code that embodies all the ETL steps that you just set up. So That allows you to put into a Jupyter notebook, which is just a, an environment for running Python code, the code that is needed to extract that data, transform it the way you specified in Data Wrangler, and apply that over and over again through that block of code as needed. So again, you know, Data Wrangler isn't really sitting in your pipeline itself, but it's producing code that goes into your pipeline. Very important distinction there.

## Troubleshooting tips

If you have trouble with Data Wrangler, there are some troubleshooting tips here. One is to make sure your Studio user, your SageMaker Studio user, has the appropriate IAM roles for Data Wrangler. And you also make sure, need to make sure that your data sources allow Data Wrangler to access it. So if Data Wrangler doesn't have permissions to access your data, that will cause problems, so you need to make sure that any data source you have has the Amazon SageMaker full access policy attached to it.

You can also run into resource limits here. So if you see an error along the lines of the following instance type isn't available that probably doesn't really mean that we're running out of instances in AWS, it just means that you may need to request a quota increase so you can use more instances than you might have originally. So if you do run into that error, you just need to go to service quotas and under there, go to Amazon SageMaker, under there, go to Studio Kernel Gateway Apps, and just request more ML dot m5 dot four x large instances. And there's a form for that, someone has to go and approve it but that's what that error message really means, you need to increase your quota. That's data wrangling in a nutshell. There's
