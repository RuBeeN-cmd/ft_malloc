_END="\033[0m"
_RED="\033[0;31m"
_GREEN="\033[0;32m"
_YELLOW="\033[0;33m"
_CYAN="\033[0;36m"

ifeq ($(HOSTTYPE),)
	HOSTTYPE := $(shell uname -m)_$(shell uname -s)
endif

LNAME = libft_malloc.so

SRC = malloc.c

NAME = $(basename $(LNAME))_$(HOSTTYPE).so
OBJ = $(addprefix $(OBJ_DIR)/, $(SRC:.c=.o))

CC = gcc
CFLAGS = -Wall -Werror -Wextra -fPIC
INC = -Iincludes -I$(dir $(LIB))/includes

LIB = libft/libft.a
LIBFLAGS = -Llibft -lft

SRC_DIR = srcs
OBJ_DIR = objs

all: $(LNAME)

$(LNAME): $(NAME)
	@ln -sf $(NAME) $(LNAME)

$(NAME): $(LIB) $(OBJ_DIR) $(OBJ)
	@echo $(_GREEN)Compiling $(OBJ)...$(END)
	@$(CC) $(CFLAGS) -shared $(OBJ) $(LIBFLAGS) -o $@

$(LIB):
	@make -C $(dir $@)

$(OBJ_DIR):
	@mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo $(_CYAN)Compiling $<...$(END)
	@$(CC) -o $@ -c $< $(CFLAGS) $(INC)

clean:
	@echo $(_YELLOW)Cleaning $(OBJ)...$(END)
	@make -C $(dir $(LIB)) fclean
	@rm -rf $(OBJ_DIR)

fclean: clean
	@echo $(_RED)Cleaning $(NAME)...$(END)
	@rm -f $(NAME) $(LNAME)

re: fclean all

test: $(NAME)
	@echo $(_YELLOW)Testing $(NAME)...$(END)
	@make -C test

.PHONY: all clean fclean re test