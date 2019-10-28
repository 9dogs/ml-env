import argparse
import os


def get_current_path():
    """Special case for Windows Docker Toolbox users."""
    current_path = os.getcwd()
    if os.getenv("DOCKER_TOOLBOX_INSTALL_PATH") is not None:
        if len(os.environ["DOCKER_TOOLBOX_INSTALL_PATH"]):
            current_path = current_path.replace(":", "")
            current_path = current_path.replace("\\\\", "/")
            current_path = current_path.replace("\\", "/")
            current_path = current_path.replace("C", "c")
            current_path = f"/{current_path}"
    else:
        current_path = f'"{current_path}"'
    return current_path


def main():
    parser = argparse.ArgumentParser(add_help=True, description="Run docker image.")
    parser.add_argument(
        "command", default="lab", help="Command (notebook | lab | shell)"
    )
    parser.add_argument(
        "--docker_tag", "-t", default="9dogs/ml:latest", help="Docker image tag"
    )
    args = parser.parse_args()
    path = get_current_path()
    run_command = (
        f"docker run -it --rm -p 4545:4545 "
        f"-v {path}:/notebooks -w /notebooks {args.docker_tag} "
        f"{args.command}"
    )
    print("Running command: ", run_command)
    os.system(run_command)


if __name__ == "__main__":
    main()
