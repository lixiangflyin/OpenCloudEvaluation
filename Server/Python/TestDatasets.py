#!/user/local/bin/python
#coding=utf-8

import sys
reload(sys) 
sys.setdefaultencoding('utf8')
import random

class TestDatasets:
	def __init__(self):
		self._courses_ = [u'大学英语',u'大学物理',u'高等数学',u'线性代数',u'工程制图',u'大学语文']
		self._teachers_ = [u'张三',u'王五',u'李四',u'赵六',u'钱七',u'孙二']
		self._rooms_ = []
		self._date_ = []
		self._time_ = []
		for i in range(len(self._courses_)):
			self._rooms_.append(u'教学楼30%d室'%i)
			self._date_.append(u'星期%d'%i)
			self._time_.append(u'1-2')
		pass

	def GetSchedules(self,count=5):
		if count > len(self._courses_):
			count = len(self._courses_)
		random.shuffle(self._courses_)
		random.shuffle(self._teachers_)
		random.shuffle(self._rooms_)
		random.shuffle(self._date_)
		random.shuffle(self._time_)
		schedules = []
		for i in range(count):
			id = '101010%d' % i
			title = self._courses_[i]
			teacher = self._teachers_[i]
			if isinstance(teacher,unicode):
				print teacher
			room = self._rooms_[i]
			date = self._date_[i]
			time = self._time_[i]
			schedules.append({'id':id,'title':title,'teacher_id':'1111','teacher_name':teacher,'room':room,'date':date,'time':time})
		return schedules
		pass


if __name__ == '__main__':
	tds = TestDatasets()
	print tds.GetSchedules(4)
