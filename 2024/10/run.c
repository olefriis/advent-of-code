#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_SIZE 100
#define MAX_POSITIONS 10000

typedef struct {
    int x;
    int y;
} Position;

typedef struct {
    Position positions[MAX_POSITIONS];
    int count;
} PositionSet;

int map[MAX_SIZE][MAX_SIZE];
int map_width = 0;
int map_height = 0;

void add_position(PositionSet *set, int x, int y) {
    // Check if position already exists
    for (int i = 0; i < set->count; i++) {
        if (set->positions[i].x == x && set->positions[i].y == y) {
            return;
        }
    }
    // Add new position
    if (set->count < MAX_POSITIONS) {
        set->positions[set->count].x = x;
        set->positions[set->count].y = y;
        set->count++;
    }
}

bool has_position(PositionSet *set, int x, int y) {
    for (int i = 0; i < set->count; i++) {
        if (set->positions[i].x == x && set->positions[i].y == y) {
            return true;
        }
    }
    return false;
}

int part_1_score(int start_x, int start_y) {
    PositionSet current_positions = {.count = 0};
    PositionSet new_positions = {.count = 0};
    
    add_position(&current_positions, start_x, start_y);
    
    for (int new_height = 1; new_height <= 9; new_height++) {
        new_positions.count = 0;
        
        for (int i = 0; i < current_positions.count; i++) {
            int x = current_positions.positions[i].x;
            int y = current_positions.positions[i].y;
            
            // Check all four neighbors
            if (x > 0 && map[y][x-1] == new_height) {
                add_position(&new_positions, x-1, y);
            }
            if (x < map_width - 1 && map[y][x+1] == new_height) {
                add_position(&new_positions, x+1, y);
            }
            if (y > 0 && map[y-1][x] == new_height) {
                add_position(&new_positions, x, y-1);
            }
            if (y < map_height - 1 && map[y+1][x] == new_height) {
                add_position(&new_positions, x, y+1);
            }
        }
        
        current_positions = new_positions;
    }
    
    return current_positions.count;
}

int part_2_score(int x, int y) {
    int current_value = map[y][x];
    
    if (current_value == 9) {
        return 1;
    }
    
    int sum = 0;
    
    // Check all four neighbors
    if (x > 0 && map[y][x-1] == current_value + 1) {
        sum += part_2_score(x-1, y);
    }
    if (x < map_width - 1 && map[y][x+1] == current_value + 1) {
        sum += part_2_score(x+1, y);
    }
    if (y > 0 && map[y-1][x] == current_value + 1) {
        sum += part_2_score(x, y-1);
    }
    if (y < map_height - 1 && map[y+1][x] == current_value + 1) {
        sum += part_2_score(x, y+1);
    }
    
    return sum;
}

int main(int argc, char *argv[]) {
    const char *filename = "10/input";
    if (argc > 1) {
        filename = argv[1];
    }
    
    FILE *file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Error: Could not open file %s\n", filename);
        return 1;
    }
    
    // Read the map
    char line[MAX_SIZE + 2];
    map_height = 0;
    while (fgets(line, sizeof(line), file)) {
        // Remove newline
        line[strcspn(line, "\n")] = 0;
        
        if (strlen(line) == 0) continue;
        
        map_width = strlen(line);
        for (int x = 0; x < map_width; x++) {
            map[map_height][x] = line[x] - '0';
        }
        map_height++;
    }
    fclose(file);
    
    // Calculate scores
    int part_1 = 0;
    int part_2 = 0;
    
    for (int y = 0; y < map_height; y++) {
        for (int x = 0; x < map_width; x++) {
            if (map[y][x] == 0) {
                part_1 += part_1_score(x, y);
                part_2 += part_2_score(x, y);
            }
        }
    }
    
    printf("Part 1: %d\n", part_1);
    printf("Part 2: %d\n", part_2);
    
    return 0;
}
