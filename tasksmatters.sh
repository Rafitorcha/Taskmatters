#! /bin/bash

if [ ! -d /opt/Taskmatters ]; then
	cd /opt
	sudo git clone -b main https://github.com/Rafitorcha/Taskmatters.git
	echo 'alias taskM="/opt/Taskmatters/tasksmatters.sh"' >>~/.bashrc
	source ~/.bashrc
else
sudo git pull origin main
fi

clock="00:00:00"

echo $(clear >&2)

textToCenter=('See notes                                           s'
	'Write a task                                        w'
	'Create task                                         c'
	'See tasks                                           s'
	'your task will be? (you can press enter to cancel!): '
	'Options for the note                                o'
	'New note                              (press any key)'
	'Done                                                d'
	'press the number of the task that you want to modify '
	'Mark as done                                        m'
	'Delete one task                                     d'
	'Delete all tasks                                    a'
	'Edit task?                                          e'
	'Count time for a task                               c'
	'Type the '
)

quit='Quit                                                q'

function session() {
	echo $(clear >&2)
	echo ''
	echo ''
	figlet -w $(tput cols) -c "TASKMATTERS"
	echo ''
	echo ''
	echo ''
	echo ''
	echo ''

	for i in {0..0}; do
		center
	done
	goBack

	echo ''

	read -s -n 1 timed

	case $timed in
	s)
		echo $(clear >&2)

		tasksMenu

		;;
	q)
		echo $(clear >&2)

		;;
	*)
		session
		;;
	esac
}

function displayTime() {
	date +%r
	sleep 1
}

function tasksMenu() {
	echo $(clear >&2)
	echo ''

	for i in {1..1}; do
		center
	done
	goBack
	read -s -n 1 timed

	case $timed in
	w)
		echo $(clear >&2)

		tareas

		;;
	q)
		echo $(clear >&2)

		session
		;;
	*)
		tasksMenu
		;;
	esac
}

function tareas() {
	echo $(clear >&2)

	for i in {2..3}; do
		center
	done
	goBack
	read -s -n 1 desition

	case $desition in
	c)
		echo $(clear >&2)
		createTask

		;;
	s)
		echo $(clear >&2)
		currentTask

		;;
	q)
		echo $(clear >&2)
		tasksMenu

		;;
	*)
		tareas

		;;
	esac
}

max=20
desition1=10

function createTask() {
	echo $(clear >&2)

	for i in {4..4}; do
		center
	done
	echo ''

	read tasks[j]
	j=$j+1

	echo ''

	for i in {5..7}; do
		center
	done

	echo ''

	read -s -n 1 desition
	case $desition in
	d)
		tareas
		;;
	o)
		currentTask
		;;
	*)
		echo $(clear >&2)

		createTask
		;;
	esac

}

function currentTask() {
	echo $(clear >&2)

	for j in {0..20}; do
		if [ -n "${tasks[j]}" ]; then
			echo $j'._ '"${tasks[j]}"
		fi
	done
	echo ''
	echo ''
	for i in {9..12}; do
		center
	done

	goBack

	read -s -n 1 desition

	case $desition in
	d)
		editTask
		j=0

		;;
	a)
		tasks=()
		currentTask
		;;
	m)
		markTask
		;;
	q)
		tareas
		;;
	e)
		editTask

		;;
	*)
		currentTask
		;;
	esac

}

function center() {

	variable=${#textToCenter}

	printf "%*s\n" $((($(tput cols) + $variable) / 2)) "${textToCenter[i]}"
	echo ''

}

function editTask() {

	for i in {8..8}; do
		center
	done

	read num

	echo 'number recibed, please type the new task!'
	echo '(press enter without text if you want delete a task)'

	for j in {0..20}; do
		if [[ "$j" -eq "$num" ]]; then
			read tasks[j]
		fi
	done

	tareas
}

function markTask() {

	for i in {8..8}; do
		center
	done

	read num
	j=$num
	echo 'number recibed, wait...'
	echo $j
	if [ "$j" -eq "$num" ] && [ -n "${tasks[j]}" ]; then
		tasks[j]="${tasks[j]} ✓"
		j=$j+1
	fi

	currentTask

}

function goBack() {

	variable=${#quit}

	printf "%*s\n" $((($(tput cols) + $variable) / 2)) "${quit}"
	echo ''

}

session
