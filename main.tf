resource "aws_vpc" "prod-rock-vpc" {
  cidr_block       = "var.cidr_block"
  instance_tenancy = "default"

  tags = {
    Name = "prod-rock-vpc"
  }
}

resource "aws_subnet" "test-public-sub1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "var.cidr_block"

  tags = {
    Name = "test-public-sub1"
  }
}


resource "aws_subnet" "test-public-sub2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "var.cidr_block"

  tags = {
    Name = "test-public-sub2"
  }
}

resource "aws_subnet" "test-private-sub1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "var.cidr_block"

  tags = {
    Name = "test-private-sub1"
  }
}


resource "aws_subnet" "test-private-sub2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "var.cidr_block"

  tags = {
    Name = "test-private-sub2"
  }
}
 

resource "aws_route_table" "test-pub-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id
  tags = {
    Name = "test-pub-route-table"
  }
}


resource "aws_route_table" "test-priv-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id
  nat_gateway_id = aws_nat_gateway.test-nat-gateway.id
  tags = {
    Name = "test-priv-route-table"
  }
}

resource "aws_route_table_association" "test-pub1-route-table-associacion" {
  subnet_id      = aws_subnet.test-public-sub1.id
  route_table_id = aws_route_table.test-pub-route-table.id
}


resource "aws_route_table_association" "test-pub2-route-table-associacion" {
  subnet_id      = aws_subnet.test-public-sub2.id
  route_table_id = aws_route_table.test-pub-route-table.id
}


resource "aws_route_table_association" "test-priv1-route-table-associacion" {
  subnet_id      = aws_subnet.test-private-sub1.id
  route_table_id = aws_route_table.test-priv-route-table.id
}

resource "aws_route_table_association" "test-priv2-route-table-associacion" {
  subnet_id      = aws_subnet.test-private-sub2.id
  route_table_id = aws_route_table.test-priv-route-table.id
}


resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = "test-igw"
  }
}


resource "aws_route" "test-route" {
  route_table_id            =  aws_route_table.test-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                =  aws_internet_gateway.test-igw.id 
    
}


resource "aws_instance" "test-serve-1" {
  ami           =  "ami-018542fa4c710a021"
  instance_type = "t2.micro"
  subnet_id     =  aws_subnet.test-public-sub1.id
  tags = {
    Name = "test-serve1"
  }
}

resource "aws_instance" "test-serve-2" {
  ami           =  "ami-018542fa4c710a021"
  instance_type = "t2.micro"
  subnet_id     =  aws_subnet.test-private-sub1.id
  tags = {
    Name = "test-serve2"
  }
}



resource "aws_security_group" "test-sec-group" {
  name        = "test-sec-group"
  description = "test-sec-group"
  vpc_id      = aws_vpc.prod-rock-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80

    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test-sec-group"
  }
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.prod-rock-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

tags = {
    Name = "test-sec-group"
  }
}   


resource "aws_eip" " test-EIP" {
 vpc      = "prod-rock-vpc"
}   

resource "aws_nat_gateway" "test-nat-gateway" {
  allocation_id = aws_eip.test-EIP.id
  subnet_id     = aws_subnet..test-public-sub1.id

  tags = {
    Name = "nat-GW"
  }  

  }  


