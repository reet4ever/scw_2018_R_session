getwd() #get
the current working directory
setwd("C:/Users/Ravneet/scw_2018/intro_R") # set the working directory

cats <- 10 # crazy cat lady

cats - 9

cats <- 9
# avoid these as variables as these are r functions
#c, C, F, t, T, S

# 6 main data types are
# characters 'abc' or "abc"
# integers 
# complex numbers 
# logicals 
# numeric 
# raw  (not going to wokr in this workshop)

class(cats)
typeof(cats)

# integer is a whole number 
i <- 2L  # assign the interger with a letter L after the number
j <- 2
class(j)
typeof(j)
class(i)
typeof(i)

#complex numbers
k <- 1 + 4i

#Logical 
#TRUE FALSE


#data structures
#atomic vector -  every element is of the same data type
#list
#matrix
#data frame

#atomic vectors - can combine only same data types, otherwise if you have other data types then it will take into account the heirarchy 
logical_vectors <- c(TRUE, TRUE, FALSE, TRUE) #c is to combine values in a vector or list
class(logical_vectors)

char_vectors <- c("Lori", "Upendra", "Chris")
class(char_vectors)
length(char_vectors)
anyNA(char_vectors) # to find missing values in a vector

# heirarchy for data types 
# characters, complex, numeric, integer, logical

mixed <- c("True", TRUE)
class(mixed)

anothermixed <- c("Stanford", FALSE, 2L, 3.14)
class(anothermixed)


# List
mylist <- list(chars = 'coffee', nums = c(1.4,5), logicals = TRUE, anotherlist = list(a = 'a', b = 2))
mylist

char_vectors[2]
mylist[2]
class(mylist)
str(mylist)   #Structure of the list


mylist[3]
mylist$logicals

# Matrix
m <- matrix(nrow = 2, ncol = 3)
class(m)
m
m <- matrix(data = 1:6, nrow = 2, ncol = 3) # data = 1:6 is the whole numbers from 1 to 6
m
m <- matrix(data = 1:6, nrow = 2, ncol = 3, byrow = TRUE) #filling th matrix by row and not col, default is by col
m


#Data Frames
df <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)  #id has letters from 1 to 10, seconf col had x with numbers from 1 to 10 and another col has numbers from 11 to 20
df
str(df) #structure of the data type
class(df)
typeof(df) # data frame is a special kind of list
head(df) # just gives first 6 rows
tail(df) # last 6 of the rows
dim(df) # dimension of the data frame with [rows,col]
names(df) # gives the col names of the data frames
summary(df) # summary of each col 


#Factor - running statistics and utilizes less memory
state <- factor(c("Arizona", "California", "Mass")) #factors dont have heirarchy
state
state <- factor(c("AZ", "CA", "CA"))
state
nlevels(state)
levels(state)

ratings <- factor(c("low", "high", "medium", "low"))
ratings

r <- c("low", "high", "medium", "low")
ratings <- factor(r)
ratings
ratings <- factor(r, levels = c("low", "medium", "high"), ordered = TRUE)
ratings
min(ratings)


survey = data.frame(number = c(1,2,2,1,2), group = c("A", "B", "A", "A", "B"))
str(survey)

Day = c(1:5) #same as 1,2,3,4,5
Magnitication = c(2,10,5,2,5)
Observation = c("Grouth", "Dealth", "No Change", "Dealth", "Growth")
data = data.frame(Day, Magnitication, Observation)
data


#import data into R
gapminder <- read.csv("gapminder-FiveYearData.csv")
dim(gapminder)
head(gapminder)
str(gapminder)
view(gapminder)

gapminder$country
gapminder[1,1] # to view specific row and col
gapminder[3,2]
gapminder[ ,1] # take every row and 1st col
gapminder[7, ] # gives only row 7 with all cols
gapminder[10:15, 5:6]
gapminder[10:15, c("lifeExp", "gdpPercap")]
gapminder[gapminder$country == "Gabon", ]

install.packages('dplyr')
library(dplyr) # select and filter 

#this is a pipe %>%

select(gapminder, lifeExp, gdpPercap)
gapminder %>% select(lifeExp, gdpPercap)
gapminder %>% filter(lifeExp > 71) # show only the rows

mexico <- gapminder %>% #new data frame as mexico
  select(year, country, gdpPercap) %>%
  filter(country == "Mexico")
View(Mexico)

#Boolean operator & == "AND", | == "OR"
#select is my col and filter is by row

data_year <- gapminder %>%
  filter(year > 1980 & continent == "Europe") %>%
  select(year, country, gdpPercap)
View(data_year)
  
#tally is a count %>% can be achieved ctrl+shift+m
names(gapminder)
gapminder %>% group_by(country) %>% tally() 

#use of arraneg function in dplyr
gapminder %>% group_by(country) %>% 
  summarise(avg = mean(pop), std= sd(pop), total = n()) %>% 
  arrange(desc(avg))

#mutate
gapminder_mod <- gapminder

#changing the actual dataframe and making a new col and displaying only the first 6 rows
gapminder_mod %>% mutate(gdp = pop * gdpPercap) %>%  head()

#Exercise 9
#Calculate the average life expectancy per country. Which nation has the longest average life expectancy and which has the shortest average life expectancy? 
gapminder %>% group_by(country) %>% 
  summarise(avg = mean(lifeExp)) %>% arrange(desc(avg)) %>% 
  filter(avg  == max(avg) | avg == min(avg)) 

#plotting
#base R plot
plot(gapminder_mod$gdpPercap, gapminder_mod$lifeExp) #gdppercap vs lifeExp
plot(x = gapminder_mod$gdpPercap, y = gapminder_mod$lifeExp) #gdppercap vs lifeExp

#ggplot2
library(ggplot2)
ggplot(gapminder_mod, aes(x = gdpPercap, y = lifeExp)) +geom_point()

#for scatter plot we need two axis and histogram we need only one 
#log 10 conversion 
ggplot(gapminder_mod, aes(x = log10(gdpPercap), y = lifeExp)) +geom_point()

#tranperancy
ggplot(gapminder_mod, aes(x = log10(gdpPercap), y = lifeExp)) +geom_point(alpha = 1/3, size = 3) #alpha is tranperancy

summary(gapminder_mod) # shows how many continents are there in the data frame
#color
p <- ggplot(gapminder_mod, aes(x = log10(gdpPercap), y = lifeExp, color = continent)) + 
  geom_point(alpha = 1/3, size = 3)

#Split the plot for each continent
p <- p + facet_wrap(~ continent)

#fit a line in the pattern
p2 <- p + geom_smooth(color = "orange")
p2

#combine dplyr with ggplot2
gapminder_mod %>%  ggplot(aes(gdpPercap, lifeExp)) + geom_point()

head(gapminder)

#now running gdp instad of gdpPercap and without creating new frame
gapminder %>% mutate(gdp = pop * gdpPercap) %>%  
  ggplot(aes(gdp, lifeExp)) + geom_point()

#histogram 
p <- gapminder_mod %>% ggplot(aes(gdpPercap, fil = continent)) + geom_histogram() #fill the color instead of outlining the color

#or
p <- ggplot(gapminder_mod, aes(gdpPercap)) +geom_histogram()
p

p3 <- ggplot(gapminder_mod, aes(lifeExp, fill = continent)) + 
  geom_histogram(binwidth = 1) + ggtitle("Histogram_gaominder")
p3


# saving plot 
ggsave(p3, file = "C:/users/Ravneet/scw_2018/advanced_R//histogram_lifeExp.png")

?ggplot # same as help


#line plot
gapminder_mod %>% filter(country == "Afghanistan") %>% summary()

gapminder_mod %>% filter(country == "Afghanistan") %>% 
  ggplot(aes(x = year, y = lifeExp)) + geom_line(color = "blue")


#2. Plot lifeExp against year and facet by continent and fit a smooth and/or linear regression, w/ or w/o facetting
q <- gapminder_mod %>% ggplot(aes(x = lifeExp, y = year)) + geom_point() + 
  facet_wrap(~ continent) + 
  geom_smooth(color = "orange", lwd = 2, se = FALSE) #lwd = thickness of the line

q1 <- q+ geom_smooth(color = "blue", lwd = 2, se = FALSE, method = "lm")
q1

ggsave(q1, file = "geom_smooth_type.png")


#density plot
ggplot(gapminder_mod, aes(gdpPercap, lifeExp)) + 
  geom_point(size = 0.25) +
  geom_density_2d() +
  scale_x_log10()

#combine plots
install.packages("gridExtra")
library(gridExtra)
gridExtra::grid.arrange(
  q3 <- gapminder_mod %>% ggplot(aes(x = lifeExp, y = year)) + geom_point() + 
    facet_wrap(~ continent) + 
    geom_smooth(color = "orange", lwd = 2, se = FALSE), 
  q4 <- ggplot(gapminder_mod, aes(gdpPercap, lifeExp)) + 
    geom_point(size = 0.25) +
    geom_density_2d() +
    scale_x_log10()
)

# loops
gapminder_mod %>% filter(continent == "Asia") %>% summarise(avg = mean(lifeExp))

contin <- unique(gapminder_mod$continent)
contin

#for (variable in list){
#  do something
#}

for (c in contin){
  #print(c)
  res <- gapminder_mod %>% filter(continent == c) %>% summarise(avg = mean(lifeExp))
  #print(c)
  #print(res)
  print(paste0("The avg life expectancy of ", c, " is:", res)) # paste0 combines stings and variables
} 


gapminder_mod %>% group_by(continent, year) %>% summarise(avg = mean(lifeExp))

# for (c in contin){
#   for(y in unique(gapminder_mod$year)){
#   #print(c)
#   res <- gapminder_mod %>% filter(continent == c) %>% summarise(avg = mean(lifeExp))
#   #print(c)
#   #print(res)
#   print(paste0("The avg life expectancy of ", c, "for the year", y " is:", res)) # paste0 combines stings and variables
#   }
# } 

#functions
mean(2,3)


adder <- function(x,y){
  print(paste0("The sum of ",x, " and ", y, " is: ", x+y))
  return(x+y)
}

adder(2,3)
