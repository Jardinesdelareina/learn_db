import requests
import environs
import psycopg2
from datetime import datetime
import time

env = environs.Env()
env.read_env('.env')

DB_USER = env('DB_USER')
DB_PASS = env('DB_PASS')
DB_HOST = env('DB_HOST')
DB_NAME = env('DB_NAME')

symbols = [
    'BTC_USDT', 'ETH_USDT', 'SOL_USDT', 'XRP_USDT',
    'ADA_USDT', 'AVAX_USDT', 'DOT_USDT', 'LINK_USDT',
]

try:
    connection = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )
    cursor = connection.cursor()

except (Exception, psycopg2.Error) as error:
    print("Ошибка подключения к базе данных:", error)



def main(symbol, interval, cursor):
    res = requests.get(
        f'https://contract.mexc.com/api/v1/contract/kline/{symbol}?interval={interval}'
    )
    res_time = res.json()['data']['time']
    res_open = res.json()['data']['open']
    res_high = res.json()['data']['high']
    res_low = res.json()['data']['low']
    res_close = res.json()['data']['close']
    data = {
        'm_symbol': symbol,
        'm_time': res_time,
        'm_open': res_open,
        'm_high': res_high,
        'm_low': res_low,
        'm_close': res_close,
    }
    '''print(
        symbol.replace("_", "").lower(), 
        datetime.fromtimestamp(data['m_time'][-1]).replace(second=0, microsecond=0), 
        data['m_open'][-1], 
        data['m_high'][-1], 
        data['m_low'][-1], 
        data['m_close'][-1]
    )'''
    
    cursor.execute(
        "INSERT INTO qts.quotes(m_symbol, m_time, m_open, m_high, m_low, m_close) VALUES (%s, %s, %s, %s, %s, %s)",
        (
            symbol.replace("_", "").lower(), 
            datetime.fromtimestamp(data['m_time'][-1]).replace(second=0, microsecond=0), 
            data['m_open'][-1], 
            data['m_high'][-1], 
            data['m_low'][-1], 
            data['m_close'][-1]
        )
    )

    connection.commit()

while True:
    for symbol in symbols:
        main(symbol, 'Min1', cursor)
    print('Отметка:', datetime.now())
    time.sleep(60)
