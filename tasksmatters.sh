#! /bin/bash

if [ ! -d /opt/Taskmatters ]; then
	cd /opt
	sudo git clone -b main https://github.com/Rafitorcha/Taskmatters.git
	echo 'alias taskM="/opt/Taskmatters/tasksmatters.sh"' >>~/.bashrc
	source ~/.bashrc
else
	cd /opt/Taskmatters/
	sudo git pull origin main
fi

clock="00:00:00"

declare -a matrix
num_rows=9
num_columns=9

for ((k = 0; k < num_rows; k++)); do
	for ((l = 0; l < num_columns; l++)); do
		matrix[k, l]=$l
	done
	matrix[k, l]=$k
done

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
	'Prepare the chronometer'
	'Press ↑ to increment'
	'Press ↓ to decrement'
	'Press ← to select the time'
	'Press → to begin'
	'¿What task do you do?'
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
	for i in {9..13}; do
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
	c)

		count
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

function mostrar_cronometro() {
	echo -e "\nCronómetro: $hora:$minutos:$segundos"
}
hora=0
minutos=0
segundos=0

function count() {
	while true; do
		echo $(clear >&2)

		for i in {14..18}; do
			center
		done

		mostrar_cronometro

		read -rsn1 tecla

		case "$tecla" in
		A)
			segundos=$((segundos + 1))
			if ((segundos >= 60)); then
				segundos=0
				minutos=$((minutos + 1))
				if ((minutos >= 60)); then
					minutos=0
					hora=$((hora + 1))
				fi
			fi
			;;
		B)
			segundos=$((segundos - 1))
			if ((segundos < 0)); then
				segundos=59
				minutos=$((minutos - 1))
				if ((minutos < 0)); then
					minutos=59
					hora=$((hora - 1))
				fi
			fi
			;;
		D)
			echo -e "\nSelecciona:\n1. Hora\n2. Minutos\n3. Segundos"
			read -rsn1 seleccion
			case "$seleccion" in
			1)
				echo -e "\nIngresa la hora:"
				read -r hora
				;;
			2)
				echo -e "\nIngresa los minutos:"
				read -r minutos
				;;
			3)
				echo -e "\nIngresa los segundos:"
				read -r segundos
				;;
			*) echo -e "\nOpción no válida" ;;
			esac
			;;
		C)

			for j in {0..20}; do
				if [ -n "${tasks[j]}" ]; then
					echo $j'._ '"${tasks[j]}"
				fi
			done
			echo ''
			echo ''
			for i in {19..19}; do
				center
			done

			read num
			j=$num
			echo 'number recibed, wait...'
			echo $j
			if [ "$j" -eq "$num" ]; then
				j=$j+1

				echo 'you know how much hilarous is not see the time but you are waiting for it?'
				echo 'you will heard a sound that can alert about the finalization of your task'

				sleep "${hora}h" "${minutos}m" "${segundos}s"
				xdg-open data/sound/BassDrop.mp3

				tareas
			fi

			;;
		q)
			tareas
			;;
		esac

	done
}

function goBack() {

	variable=${#quit}

	printf "%*s\n" $((($(tput cols) + $variable) / 2)) "${quit}"
	echo ''

}

session
