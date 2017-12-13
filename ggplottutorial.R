#### GGPLOT Tutorial--------------
# Franklin Sayre
# December 2017
####

# Resources-----------
# Website: http://had.co.nz/ggplot2/ 
# Documentation: http://ggplot2.tidyverse.org/reference/ 
# Cheat sheet: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf 
# Install with: install.packages("ggplot2")

#Set environment-------------

setwd("~/Dropbox/Learning R/ggplottutorial")
library(ggplot2)
library(dplyr)


#Gapminder data -------------
gapminder
str(gapminder)
head(gapminder)
tail(gapminder)

# We also have built-in Starwars data but I've only really seen the original 3 movies (don't @ me)  so we're not going to use that today. 

starwars
str(starwars)
tail(starwars)

# ggplot -----------------
# ggplot is a system for creating graphics, specifically plots, using something classed the grammar of graphics. You provide data, tell ggplot how to map variables to aestetics, and graphical rules to follow, and it builds plots.

# Let's start by plotting gdpPerCap and lifeExp to see the relationship between the two
# We start by calling the function, then tell it the data to use, then define aestetics (aes) to tell it how to map variables, then we tell it what kind of plot to create


ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()


# Hard to really see differences here so lets us scale using a logorithmic scale to spread out the valies
# Note that we do this by adding a new element as a layer to the end of our previous code

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10()

# This is much better. Lets add continents by color to see if there is a relationship between which continents a country is on and it's GDP and LifeExp 

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  scale_x_log10()


# This is getting to be a messy chart! Let's add one more thing to it! Let's look at means

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  scale_x_log10() +
  geom_smooth() +
  theme_classic()

gapminder <- gapminder

Africa <- gapminder %>%
  filter(continent == "Africa")

ggplot(Africa, aes(x = gdpPercap, y = lifeExp, size = pop)) +
  geom_point() +
  scale_x_log10() +
  geom_smooth()

ggplot(Africa, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  scale_x_log10() +
  geom_smooth() +
  expand_limits(y = 0)

# We could also use something like transparency to represent population

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(aes(alpha = pop)) +
  scale_x_log10()

# That is TERRIBLE, instead lets use SIZE to represent population, COLOR to represent continents

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(aes(size = pop)) +
  scale_x_log10()

# Faceting ----------

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop)) +
  scale_x_log10() +
  facet_wrap('continent')

# Now lets see how life expectancy has changed over time. To do this we will use a line chart, with year as our X axis. 

ggplot(gapminder, aes(x = year, y = lifeExp, by = country, color = continent)) +
  geom_line() 


# BOXPLOTS for life expectancy 
# MAX, MIN, 1st and 3rd quartile, median

ggplot(gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot()

# More Aestetics ---------
#position (i.e., on the x and y axes)
#color (“outside” color)
#fill (“inside” color)
#shape (of points)
#linetype
#size

ggplot(gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot() +
  ggtitle("Box Plot of LifeExp & GDP") +
  ylab("Life Expectancy")


# Take out background
ggplot(gapminder, aes(x = year, y = lifeExp, by = country, color = continent)) +
  geom_line() +
  theme_classic()

# More charttypes -------- 



# dplyr --------------

# This is a big data set, lets use dplyr to make it a little more reasonable

# first lets move this built-in dataset into a dataframe
gapminder <- gapminder

# Then lets pull out data for just the Americas
Americas <- gapminder %>%
  filter(continent == 'Americas')

ggplot(Americas, aes(x = year, y = lifeExp, color = country)) + 
  geom_line()

# add boxplots 

ggplot(Americas, aes(x = year, y = lifeExp, color = country)) + 
  geom_line() +
  geom_boxplot()

# UGH. Terrible. We could also pull out an individual country

Canada <- gapminder %>%
  filter(country == 'Canada')

ggplot(Canada, aes(x = year, y = lifeExp, size = pop)) + 
  geom_line() 


## Desktracker 'data' ---------------

desktracker <- read.csv('Desk_Tracker_12-1-15_through_12-1-17.csv')

desktracker
str(desktracker)

#$ fix date times encoding
#desktracker$datetime <- strptime(x = as.character(desktracker$date_time), format = "%Y-%m-%d %H:%M:%S")

desktracker$datetime <- as.POSIXct(strptime(x = as.character(desktracker$date_time), format = "%Y-%m-%d %H:%M:%S"))

desktracker$year <- format(desktracker$datetime,'%Y')


ggplot(desktracker, aes(x = datetime, y = response)) +
  geom_point()

# bar chart by response
ggplot(desktracker, aes(x = response)) +
  geom_bar()


# That was a nightmare!
# Filter to just length of response

TrackerDuration <- filter(desktracker, question == "Transaction Duration")

ggplot(TrackerDuration, aes(x = response)) +
  geom_bar()

ggplot(TrackerDuration, aes(x = year, y = response)) +
  geom_point()

### Filter to just user type

TrackerUserType <- filter(desktracker, question == "User Type")

str(TrackerUserType)

# remove unused factors
TrackerUserType$response <- factor(TrackerUserType$response)

ggplot(TrackerUserType, aes(x = response)) +
  geom_bar()




# tying this thing lisa told me to do


UserTypeFreq <- as.data.frame(table(TrackerUserType$response, TrackerUserType$year))
  

str(UserTypeFreq)

ggplot(UserTypeFreq, aes(x = Var2, y = Freq, color = Var1)) +
  geom_point() +
  geom_line(aes(linetype = Var1))

ggplot(UserTypeFreq, aes(x = Var2, y = Var1, size = Freq)) +
  geom_point()

ggplot(UserTypeFreq, aes(x = Var2, y = Freq)) +
  geom_point()
