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
```
  
### Examples
Directory structure:
```
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
  |
[...]
```

**Task 1**: Find every non-square image in 'Pokémon/' subdirectories and log their path to 'log.txt'.
```shell
user@hostname: ~$ ./img_script -d Pokémon/ -s -l log.txt
```

```'-d Pokémon/' tells the script we want to check all the images in Pokémon/ subdirectories```\
```'-s' tells the script we want to check if the images are squared```\
```'-l log.txt' tells the script to log the incorrect images to the file log.txt```

**Task 2**: Find every image, in 'Pokémon/' subdirectories, which height or width is less than 250, and also rename them with the name of their parent folder.
```shell
user@hostname: ~$ ./img_script -d Pokémon/ -m 250 -r
```

```'-d Pokémon/' tells the script we want to check all the images in Pokémon/ subdirectories```\
```'-m 250' tells the script we want to check if the minimum of the dimension of the images is 250```\
```'-r' tells the script we want to rename each image with its parent folder```

### Dependancies
ImageMagick package must be installed.

### To-Do
- [ ] Fix filename with spaces bug;
- [ ] Fix the rename bug which deletes some files if they're already named in the same way;
- [ ] Add extension check (specify a list of extensions, e.g. '.jpg, .png');

