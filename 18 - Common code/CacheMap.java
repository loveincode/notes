package com.kedacom.tsu.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CacheMap {
private static Map<String,Object> map=null;
	
	private long cacheTime=30000;//单位秒,默认值为30s
	
	private static CacheMap instance = new CacheMap();
	
	public static CacheMap getInstance() {
		return instance;
	}
	
	public CacheMap(){		
		//线程，定时清除超时的缓存
		synchronized ("lazy") {
			if(map == null){				
				map=new HashMap<String, Object>();
			}		
		}
		
	}
	
	//存值,不设置时，超时时间默认为30s
	public void put(String key,Object value){
		synchronized(map){
			clearTimeOutCache();
			Map<String,Object> dataWithTime=new HashMap<String, Object>();
			dataWithTime.put("lastTimeMillis", System.currentTimeMillis());
			dataWithTime.put("outTimeMillis", cacheTime);
			dataWithTime.put("data", value);
			map.put(key, dataWithTime);
		}
	}
	
	//存值带超时时间,超时时间小于0时，永不超时
	public void put(String key,Object value,Long outTimeMillis){
		synchronized(map){
			clearTimeOutCache();
			
			Map<String,Object> dataWithTime=new HashMap<String, Object>();
			dataWithTime.put("lastTimeMillis", System.currentTimeMillis());
			dataWithTime.put("outTimeMillis", outTimeMillis);
			dataWithTime.put("data", value);
			map.put(key, dataWithTime);
		}
	}
	
	//取值
	public Object get(String key){
		synchronized (map) {	
			Map<String,Object> dataWithTime=(Map<String, Object>) map.get(key);
			if(dataWithTime !=null){							
				dataWithTime.put("lastTimeMillis", System.currentTimeMillis());				
				return dataWithTime.get("data");
			}else{
				return null;
			}
		}
	}
	
	//移除
	public void remove(String key){
		synchronized (map) {
			map.remove(key);
			System.out.println("clearMapCache :=====> key:"+key);
		}
	}
	
	
	//移除过期缓存
	public void clearTimeOutCache(){
		synchronized (map) {	
			List<String> keyList=new ArrayList<String>();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key=entry.getKey();
				Map<String, Object> dataWithTime=(Map<String, Object>) entry.getValue();
				
				if(dataWithTime !=null){				
					Long lastTimeMillis=(Long) dataWithTime.get("lastTimeMillis");
					Long outTimeMillis=(Long) dataWithTime.get("outTimeMillis");
					Long currentTimeMillis=System.currentTimeMillis();
					if(outTimeMillis<0){//小于0时，永不超时
						continue;
					}
					if(currentTimeMillis-lastTimeMillis>outTimeMillis){	
						keyList.add(key);
					}
				}
			}
			for(String key:keyList){
				map.remove(key);
				System.out.println("clearMapCache :=====> key:"+key);
			}
		}
	}
}
