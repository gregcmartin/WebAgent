
import subprocess
import threading

def start_fastapi():
    subprocess.run(["poetry", "run", "uvicorn", "src.oai_agent.oai_agent:app", "--reload", "--host", "0.0.0.0", "--port", "3030"])


def main():
    fastapi_thread = threading.Thread(target=start_fastapi)

    fastapi_thread.start()

    fastapi_thread.join()

if __name__ == "__main__":
    main()
