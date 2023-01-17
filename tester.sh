generate_list()
{
  list=$(awk -v loop=$1 -v range=2147483647 'BEGIN{
    srand()
    do {
      numb = 1 + int(rand() * range)
      if (!(numb in prev)) {
         print numb
         prev[numb] = 1
         count++
      }
    } while (count<loop)
  }')
}

if [ "$(uname -s)" = "Darwin" ]; then
  os="mac"
elif [ "$(uname -s)" = "Linux" ]; then
  os="linux"
else
  printf "\033[1;31mYour os has no supported checker, exit.\033[1;00m"
  exit 1
fi

test()
{
  i=0
  generate_list $1
  printf "\033[1;36m$1 numbers list: "
  echo "$1 Numbers list" >> log.txt
  while [ $i -lt 100 ]; do
    output="$(../push_swap $list | ./checker_$os $list)"
    if [ "$output" = "KO" ]; then
      printf "\033[1;31m[$i: KO]\033[1;00m"
    elif [ "$output" = "Error" ]; then
      printf "\033[1;31m[$i: Error]\033[1;00m"
    else
      printf "\033[1;32m[OK]\033[1;00m"
    fi
    echo "\tTest $i: $list" | tr '\n' ' ' >> log.txt
    echo "\n" >> log.txt
    generate_list $1
    ((i++))
  done
  echo "\n"
}

get_instructions_count()
{
  count="$(./complexity $1 100 1)"
  printf "Nombre d'instructions pour le pire des cas: "
  echo $count | awk '{printf $13}'
  echo "\n"

}

rm log.txt
test 3
get_instructions_count 3
test 5
get_instructions_count 5
test 100
get_instructions_count 100
test 500
get_instructions_count 500

