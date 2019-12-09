# Task1: WrapperNSMutableArray
before using GCD: (a thread write data when other not yet finish)
<img src="https://user-images.githubusercontent.com/28861842/70414613-362f4580-1a8d-11ea-84e2-14e3c90cb45c.png">

after: (pre and done work together mean no read data at same time)
<img src="https://user-images.githubusercontent.com/28861842/70414481-c8831980-1a8c-11ea-9984-6aeca6739c1e.png">
