echo "_______________________ Word Count example _______________________"
echo "with 1 master (VM) and 2 slaves (VM)"
echo ""

echo "Be flexible! XD"
echo ""

echo "To try another configuration, please either modify 'begin.sh' or directly run the command with this format:"
echo ""
echo "    ' bash start.sh [# of slave(s)] path/to/file.jar path/to/file_data.txt jar_class_name '     "
echo ""
echo " XD __ (assuming there exists already a file.jar, knowing it's class name) __ XD"
echo ""

sleep 20
bash start.sh 2 ./examples/wc.jar ./examples/filesample.txt WordCount

