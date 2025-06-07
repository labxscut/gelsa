import argparse
import csv
import numpy as np

def write_array_to_csv(array, filename):
    rows, cols = array.shape
    col_title_length = max(len('series{}'.format(i)) for i in range(1, cols + 1)) + 5
    row_title_length = max(len('series{}'.format(i + 1)) for i in range(rows)) + 2
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        col_titles = ['series{}'.format(i).ljust(col_title_length) for i in range(1, cols + 1)]
        writer.writerow(['#' + ''.ljust(row_title_length - 1)] + col_titles)
        
        for i in range(rows):
            row_title = 'series{}'.format(i + 1).ljust(row_title_length)
            data_titles = ['{}'.format(array[i][j]).ljust(col_title_length) for j in range(cols)]
            writer.writerow([row_title] + data_titles)


def main():
    
    in_data = np.random.rand(10, 20)

    write_array_to_csv(in_data, 'input_01.csv')

    csv_file = 'input_01.csv'
    with open(csv_file, 'r', newline='') as f:
        reader = csv.reader(f)
        rows = list(reader)
        
    for row in rows:
        for i in range(len(row)):
            row[i] = row[i].replace(',', '\t')
            
    new_csv_file = 'test.txt'  # 输出文件路径
    with open(new_csv_file, 'w', newline='') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerows(rows)

if __name__ == "__main__":
    main()
