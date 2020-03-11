from flask import Flask, request, Response
import mysql.connector
import os
import json
from copy import deepcopy, copy

admin = Flask(__name__)

config = {
	'user': 'admin_cinema_service',
	'password': 'supersecret_admin',
	'host': 'db',
	'port': '3306',
	'database': 'cinema_service'
}

cursor = None
connection = None

@admin.route('/cinema_hall/add', methods = ['POST'])
def add_cinema_hall():
	name = request.form.get('name')
	number_of_rows = request.form.get('number_of_rows')
	number_of_seats_per_row = request.form.get('number_of_seats_per_row')

	if 	not name or not number_of_rows or not number_of_seats_per_row:
		return 'Sala de cinema nu a putut fi adaugata (parametri invalizi)', 401

	connect_to_db()
	cursor.execute('add_cinema_hall', [name, number_of_rows, number_of_seats_per_row])
	cursor.close()

	return 'Sala de cinema adaugata cu succes', 200

def connect_to_db():
	global connection
	global cursor

	connected = None

	while not connected:
		try:
			connection = mysql.connector.connect(**config)
			cursor = connection.cursor()
			connected = True
		except:
			connected = False

if __name__ == '__main__':
	connect_to_db()
	cursor.close()

	admin.run(host='0.0.0.0', port=os.getenv('PORT', 8000), debug=True)
