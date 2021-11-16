# ImageFormatChecker
A bash script to check the dimensions of images recursively, using getopts and find.

### Usage
```shell
img_checker.sh [OPTION...]

OPTIONS:
-d <dir_name>, specify the directory inside which the script will loop
-l <file_name>, the script will log the images that aren't correct into <file_name>
-m <min_dim>, the script will check if the dimension of the images are beyond the minimum <min_dim>
-M <max_dim>, the script will check if the dimension of the images are beyond the maximum <max_dim>
-s, the script will check if the images are squared (i.e. NxM with N == M)
-r, rename each file with the name of its parent folder, followed by its index inside the directory
  example: /Pokémon/Voltorb/cbahf4kasdm3.jpg -> /Pokémon/Voltorb/Voltorb1.jpg
  
EXAMPLES:
Directory structure:
./Pokémon/
  |
  +-- Bulbasaur/
  |     |
  |     +-- img1.jpg, img2.png, [...]
  |
  +-- Charmander/
  |     |
  |     +-- img1.jpg, img2.png, [...]
  |
  +-- Squirtle/
  |     |
  |     +-- img1.jpg, img2.png, [...]
[...]

Task: log all the non squared images in Pokémon/ subdirectories.
user@hostname: ~$ ./img_script -d Pokémon/ -s -m 250 -l log.txt

  '-d Pokémon/' tells the script we want to check all the images in Pokémon/ subdirectories
  '-s' tells the script we want to check if the images are squared
  '-l log.txt' tells the script to log the incorrect images to the file log.txt
```

### Dependancies
ImageMagick package must be installed.

### To-Do
Add extension check (specify a list of extensions, e.g. '.jpg, .png')
