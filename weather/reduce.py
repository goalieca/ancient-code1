#!/usr/bin/python
import csv,glob,math

CONDITIONS_ENUM = ['Cloudy','Rain','Clear','Drizzle','Snow','Fog']

#each month is a seperate file
file_list = glob.glob('*.csv')
daily_records = dict() #contains the outcome for each day
for file_name in file_list:
    
    #open file, skip past metadata to 17th line 
    file_handle = open(file_name,'r')
    for i in range(1,17):
        file_handle.readline()
    csv_reader = csv.DictReader(file_handle)

    #records are given for each hour in each day of the month
    #this groups them into a count of conditions observed for
    #each day
    monthly = dict()
    for row in csv_reader:
        day = "{0}-{1}-{2}".format(row['Year'],row['Month'],row['Day'])
        if day not in monthly:
            monthly[day] = dict()
        daily = monthly[day]
        #count number of times a condition occurs in a day
        for condition in CONDITIONS_ENUM:
            if condition in row['Weather']:
                if condition in daily:
                    daily[condition] = daily[condition] + 1
                else:
                    daily[condition] = 1

    #find the condition that occurs most often for each day
    for day in monthly:
        daily = monthly[day]
        if len(daily) is 0:
            del daily
            continue
        if 'Rain' in daily and daily['Rain'] > 1:
            daily_records[day] = 'Rain'
        else:
            condition,_ = max(daily.iteritems(), key = lambda x:x[1])
            daily_records[day] = condition

#find the probability of each weather condition (independant)
#compute p(a)
probability = dict()
observations = daily_records.values()
first_day = sorted(daily_records)[0]
num_records = len(daily_records)
for condition in CONDITIONS_ENUM:
    #conditional prob starts at day 2, so this should too
    if condition is daily_records[first_day]:
        probability[condition] = float(observations.count(condition)-1) / (num_records - 1)
    else:
        probability[condition] = float(observations.count(condition)) / (num_records - 1)

#find conditional probability of today with day before
#compute p(B | A) = p (B and A) / p(A)
conditional_probability = dict()
sorted_keys = sorted(daily_records) #fetches days in order
for i in range(1,num_records):
    condition_B = daily_records[sorted_keys[i]]
    condition_A = daily_records[sorted_keys[i-1]]
    key = (condition_B, condition_A)
    denom = (num_records-1) * probability[condition_A]
    if key in conditional_probability:
        conditional_probability[key] = conditional_probability[key] + 1.0 / denom
    else:
        conditional_probability[key] = 1.0 / denom

#now to compute the entropy
# H(Y|X) = - sum(p(x) sum(p(y|x) log(p(y|x))
entropy = 0.0
for x in probability:
    pyxs = [conditional_probability[yx] for yx in conditional_probability if x is yx[1]]
    entropy_yx = -sum( [pyx * math.log(pyx,2) for pyx in pyxs] )
    entropy = entropy + probability[x] * entropy_yx

#find max entropy
num_conditions = len(CONDITIONS_ENUM)
entropy_max = math.log(num_conditions,2)

print("Measured Entropy (bits) = {0}".format(entropy))
print("Theoretical max: {0}".format(entropy_max))
print("Probability('Cloudy') = {0}".format(probability['Cloudy']))
print("Probability('Rainy') = {0}".format(probability['Rain']))
