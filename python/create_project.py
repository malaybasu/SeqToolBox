import os
import json
import argparse
from datetime import datetime

def create_project(dir_name):
    # Get the current date in DDMMYYYY format for VERSION
    current_date = datetime.now().strftime("%Y%m%d")
    
    # Create the full directory name with the date prepended
    full_dir_name = f"{current_date}-{dir_name}"
    
    # Create the project directory
    os.makedirs(full_dir_name, exist_ok=True)
    
    # Define the subdirectories to create
    subdirs = ['in', 'src', 'out/tables', 'out/figures', 'out/objects']
    
    # Create subdirectories
    for subdir in subdirs:
        os.makedirs(os.path.join(full_dir_name, subdir), exist_ok=True)
    
    # Create the Jupyter notebook content
    notebook_name = f"{current_date}-{dir_name}.ipynb"
    notebook_path = os.path.join(full_dir_name, notebook_name)
    
    # Define the basic structure of the notebook
    notebook_content = {
        "cells": [
            # Markdown cell for project name
            {
                "cell_type": "markdown",
                "metadata": {},
                "source": [
                    f"# Project Notebook: {current_date}-{dir_name}"
                ]
            },
            # Code cell for setting the VERSION variable
            {
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "outputs": [],
                "source": [
                    f"# Set the project VERSION\n",
                    f"VERSION = '{current_date}'  # Current date in DDMMYYYY format"
                ]
            },
            # Code cell with placeholder for user code
            {
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "outputs": [],
                "source": [
                    "# Write your code here"
                ]
            }
        ],
        "metadata": {},
        "nbformat": 4,
        "nbformat_minor": 5
    }
    
    # Write the notebook content to the .ipynb file
    with open(notebook_path, 'w') as notebook_file:
        json.dump(notebook_content, notebook_file, indent=4)

    readme_content = f"""# README """

    # Write the README.md content to the file
    readme_path = os.path.join(full_dir_name, "README.md")
    with open(readme_path, 'w') as readme_file:
        readme_file.write(readme_content.strip())    
    
    print(f"Project structure created successfully!\nDirectory: {full_dir_name}\nNotebook: {notebook_path}")

def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Create a project directory with a predefined structure and a Jupyter notebook.")
    parser.add_argument('project_name', type=str, help='The name of the project')
    
    args = parser.parse_args()
    
    # Call the function to create the project
    create_project(args.project_name)

if __name__ == "__main__":
    main()

