#!/usr/bin/env python
# coding: utf-8

# In[13]:


import pandas as pd


# In[14]:


pd.__version__


# In[15]:


from sqlalchemy import create_engine


# In[16]:


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[17]:


engine.connect()


# In[18]:


#set df

df = pd.read_csv('green_tripdata_2019-10.csv.gz', nrows=0)


# In[19]:


#to create schema

df.head(n=0).to_sql(name='green_taxi_data', con=engine, if_exists='replace')


# In[20]:


df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)


# In[21]:


print(pd.io.sql.get_schema(df, name='green_taxi_data', con=engine))


# In[22]:


#select rows from file

df_iter = pd.read_csv('green_tripdata_2019-10.csv.gz', iterator=True, chunksize=100000)


# In[23]:


from time import time


# In[24]:


while True: 
    try:
        t_start = time()
    
        df = next(df_iter)
    
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

        # insert rows into table
        df.to_sql(name='green_taxi_data', con=engine, if_exists='append')
    
        t_end = time()

        print('inserted another chunk, took %.3f second' % (t_end - t_start))
        
    except StopIteration:
        print("All data has been inserted into the database.")
        break


# In[26]:


#select rows from file

df_zones = pd.read_csv('taxi_zone_lookup.csv')


# In[27]:


# to create schema

df_zones.head(n=0).to_sql(name='taxi_zone_lookup', con=engine, if_exists='replace')


# In[28]:


# insert rows into table

df_zones.to_sql(name='taxi_zone_lookup', con=engine, if_exists='append')


# In[ ]:




