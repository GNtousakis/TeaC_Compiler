flex mylexer.l
bison -d -v -r all myanalyzer.y
gcc -o mycompiler myanalyzer.tab.c lex.yy.c cgen.c -lfl

sleep_time=2

echo -e "\n\n"
echo -e "---------------------- First we will compile the given examples --------------------------"
echo -e "---------------------- to demonstrate that everything works ---------------------------"
echo -e "-------------------------------------------------------------------------------------\n"

echo -e "\n\n"
echo -e "---------------------- We compile the first file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < examples/useless.tc > examples/useless.c
sleep ${sleep_time}


echo -e "\n\n"
echo -e "---------------------- We compile the second file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < examples/prime.tc > examples/prime.c
sleep ${sleep_time}


echo -e "\n\n"
echo -e "---------------------- We compile the third file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < examples/myprog.tc > examples/myprog.c
sleep ${sleep_time}

echo -e "\n\n"
echo -e "---------------------- After that we will compile my examples --------------------------"
echo -e "---------------------- to demonstrate that everything works ---------------------------"
echo -e "-------------------------------------------------------------------------------------\n"

echo -e "\n\n"
echo -e "---------------------- We compile the first file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < my_examples/mine_1.tc > my_examples/mine_1.c
sleep ${sleep_time}


echo -e "\n\n"
echo -e "---------------------- We compile the second file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < my_examples/mine_2.tc > my_examples/mine_2.c
sleep ${sleep_time}


echo -e "\n\n"
echo -e "---------------------- We compile the third file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < my_examples/mine_3.tc > my_examples/mine_3.c



echo -e "\n\n"
echo -e "---------------------- After that we will try to compile  examples --------------------------"
echo -e "---------------------- to demonstrate that some things dont works ---------------------------"
echo -e "--------------------------------------------------------------------------------------------\n"

echo -e "\n\n"
echo -e "---------------------- We compile the first file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < not_working_examples/it_wont_work.tc
sleep ${sleep_time}


echo -e "\n\n"
echo -e "---------------------- We compile the second file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < not_working_examples/it_wont_work_2.tc
sleep ${sleep_time}


echo -e "\n\n"
echo -e "---------------------- We compile the third file -------------------------"
echo -e "-----------------------------------------------------------------------\n"

./mycompiler < not_working_examples/it_wont_work_3.tc
