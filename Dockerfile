from public.ecr.aws/sam/build-python3.9:latest

run mkdir /tmp/layer
workdir /tmp/layer
add requirements.txt /tmp/layer/requirements.txt

cmd ["pip", "install", "-r", "requirements.txt", "-t", "python"]

