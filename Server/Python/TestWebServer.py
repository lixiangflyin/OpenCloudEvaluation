#!/user/local/bin/python
#coding=utf-8


# 用 bottle 建立一个非常简单的本地测试 Web 服务器

from bottle import route,run,template
from TestDatasets import *
import json

# 测试bottle web server 是否正常运行
@route('/hello/:name')
def index(name='world'):
	return template('<h1>Hello</h1><br/><p>{{name}}</p>',name=name)

# 用户登录，三种角色 teacher:教师 master:督导 student:学生
@route('/login/:id')
def index(id):
	if id == '101011111':
		title = 'teacher'
	if id == '202022222':
		title = 'master'
	if id == '303033333':
		title = 'student'
	value = [{'success':'true'},{'id':id,'title':title}]
	return json.dumps(value)


# 获取本周课表
@route('/schedule/thisweek')
def index():
	tds = TestDatasets()
	return json.dumps(tds.GetSchedules(),ensure_ascii=False)

# 上传评价
@route('/evaluate/:id/:score/:msg')
def index(id,score,msg=''):
	return template('<ul><li>{{id}}</li><li>{{score}}</li><li>{{msg}}</li>',id=id,score=score,msg=msg)

run(host='localhost',port=8080)