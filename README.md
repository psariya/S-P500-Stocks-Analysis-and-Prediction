# S-P500-Stocks-Analytics-and-Prediction

## TASK #1
The task is to model S & P 500 with other events such as Interest Rates (10 yr US treasury), Dollar index values, energy prices, etc. Then train this model with the old data and test it on the newer data and see if we can predict what our stock prices will be for tomorrow.
<br>Prediction is always fun. Who doesn’t want to know what will happen tomorrow! I was able to train our model to a certain extent. I was able to predict the prices by only being 2.5% off the actual value of the next day. Phew! That’s a good accuracy. But still it’s a not perfect result. 
<br>I downloaded my data from Yahoo Finance – S & P 500 (just the adjusted close price), 10yr US treasury, and US Dollar index rates. These were then loaded into dataframes and then merged together into one dataframe corresponding to their dates. My data had null values, so I got rid of those records that had NULLs or NAs. Then, I calculated percentage change for my data. The percentage change from yesterday to today, from 2 days ago to yesterday, from 3 days ago to 2 days ago, from 4 days ago to 3 days ago, from 5 days ago to 4 days ago. I finally generated 15 columns – 5 for each of the three datasets.
<br>My next step was to eliminate the variables that were highly correlated. Well, the cor() function in R was pretty useful for this. When used on the entire dataset with 15 variables, I found that none of them are highly correlated. So, my next approach was to use the regresssion model to find the t-values and p-values of each of the independent variables. I chose ‘percentage change from yesterday to today’ as my dependent variable. I was able to eliminate most of my independent variables through this. The lower the t-values, the less significant the variables are, and so are the variables with higher the p-values (above 5%)  In the end, I was left with 1 variable from each category, that is, S & P 500 percentage change from 2 days ago to yesterday, Interest rate percentage change from yesterday to today, and Dollar index percentage change from yesterday to today. I now had new linear equation that I could use to predict my values. 
<br>I then segregated my data into training and testing datasets, based on dates – training will have data before 2018, and testing will have data of 2018 only. I trained my model with the new linear equation I produced before, and then used this trained model to predict the values of my test datasets. This is where I found that I am about 2.5% off the actual prices of 2018. 
<br>We could try creating models with different events such as energy, unemployment rates, and economic growth, but predicting the stock market will always be a challenge. And from what I have heard, nobody has been able to predict the market with 100% accuracy for everyday day-after-day. But this hasn’t stopped the statisticians from taking up the challenge.

## TASK #2


With the stock market information, we want to predict when a day might be bad (<-1%), poor (-1%<x<0), good(0<x<1%), and great (>1%).  Thus, using the data from HW2, instead of predicting up or down, or predicting the value, see if we can use the lag variables to predict the classifications above.<br>
Using Bayes and LDA to predict the classes above and see if either does better.  Trained data up through the end of 2017 and tested it on 2018 data using S&P 500, Dollar and Interest Rate. <br>
The assignment is to predict the lag from yesterday’s stock and today’s stock value using Bayes model and Linear Discriminant Analysis and then compare and contrasts the predictions by the two models.<br>
I used the Bayes model first to do the predictions. The data for first divided into training and testing sets and the bayes model was run on the training set. The model thus generated was tested on the testing set. This testing was done to predict the classification, that is, if the day is bad, poor, good or great. <br>
Next I used the LDA model for predictions. Again, the model was trained using training set and then the resulted model was used to predict the classifications in the testing set.<br>
The accuracy of the two models was as below –<br>
**Bayes Model**
> table(pred.classify$class, my.test$classify)

|       | bad   | good  | great | poor |
| ------|:------|:------|:------|:-----|
| bad   | 1     | 0     | 0     | 2    |
| good  | 9     | 56    | 11    | 27   | 
| great | 1     | 1     | 6     | 0    |
| poor  | 5     | 31    | 3     | 37   |
        
        
> mean(pred.classify$class == my.test$classify)<br>
[1] 0.5263158

<br><br>**LDA Model**
> table(my.test$lda.pred.classify, my.test$classify)

|       | bad   | good  | great | poor |
| ------|:------|:------|:------|:-----|
| bad   | 3     | 1     | 0     | 3    |
| good  | 10    | 74    | 13    | 46   | 
| great | 0     | 0     | 5     | 0    |
| poor  | 3     | 13    | 2     | 17   |

<br>> mean(my.test$lda.pred.classify == my.test$classify)<br>
[1] 0.5210526

<br>So we see that Bayes and LDA models gave about the same level of accuracy of above 52%, with Bayes giving slightly better accuracy by 0.5%
