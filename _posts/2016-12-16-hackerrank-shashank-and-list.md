---
layout: post
title: HackerRank – Shashank and List
published: true
url_challenge: https://www.hackerrank.com/challenges/shashank-and-list
---

Problem [Shashank and List]({{ page.url_challenge }}) is a math problem that asks for computing the sum $P = \sum_{i=1}^{2^N-1} 2^{S_i}$, where $S_i$ is the sum of all the elements of the $i^{th}$ non-empty sublist of a list A of $N$ elements. Since this value can be huge, we need to report $P \% (10^9+7)$ instead.

<!--more-->

The brute-force approach seems to be rather trivial: compute each $S_i$ and plug them in the sum. The problem with this approach is that there are $2^N-1$ possible sublists of A, and $N$ can be huge -- see constraints above.

### Constraints

* $1 \le N \le 10^5$
* $0 \le A_i \le 10^{10}$


<div class="message">
No spoiler alerts, press the button below to reveal the solution
</div>
<button class="toggle-solution show" href="#">Show solution</button>
<button class="toggle-solution hide" href="#">Hide</button>

{% solution %}
## Solution

It turns out that there's a very neat way to sidestep this issue of explicitly computing the sum of the elements of every sublist $S_i$.

Since $S_i$ represents a sum of elements, let us unfold each of the terms $2^{S_i}$ into the equivalent product of powers of 2, with exponents equal to the elements of the corresponding sublist. Now, each element $a$ of $A$ will appear in the sum $P$ as $2^a$ in every sublist that contains it, and be absent on all sublists that do not contain it. We want to avoid accounting the presence and absence of each element, since this will ultimately lead to enumerating all possible $2^N$ sublists. So how can we still compute this sum?

As it turns out, there's a neat way to sidestep this issue, by rewriting our equation:

$$
\begin{array}{rl}
 P &= 2^{S_1} + 2^{S_2} + \dots + 2^{S_{2^N-1}} \\
   &= (2^{A_1} + 1)(2^{A_2} + 1) \dots (2^{A_N} + 1) - 1
\end{array}
$$

In this way, all the possible sublists are implicitly taken into account, as the choice of presence/absence is given by adding 1 to each of the $2^{A_i}$ terms. We still need to subtract 1 at the end, since we are only interested in non-empty sublists.

Now, the only difficulty is in computing each of the powers $2^{A_i}$ in a fast way, which can be done in $O(log(10^{10}))$ using exponentiation by squaring. Hence, the total complexity is $O(Nlog(10^{10}))$.

### Using DP

The above formula could also be derived from applying Dynamic Programming to the problem: let $DP[i]$ be the solution using the the first $i$ elements of $A$. Then $DP[i+1]$ must be the solution that accounts for all the subsets accounted in $DP[i]$, as well as those that now contain $A_{i+1}$. The sum of these new subsets is simply $2^{A_{i+1}} \cdot DP[i]$. Thus:

$$
\begin{array}{rl}
  DP[i] &= DP[i-1] + 2^{A_{i+1}} \cdot DP[i] \\
        &= (2^{A_{i+1}} + 1) \cdot DP[i-1]
\end{array}
$$

### Code

The input format is explained [here]({{ page.url_challenge }}).
{% highlight python %}
#!/usr/bin/env python3
read_ints = lambda : list(map(int, input().split()))

def power_mod(N, k, MOD):
    if k == 0:
        return 1
    if k % 2 == 0:
        return (power_mod(N, k/2, MOD) ** 2) % MOD
    return (N * (power_mod(N, (k-1)/2, MOD) ** 2 % MOD)) % MOD

def solve(N, A, MOD):
    ans = 1
    for a in A:
        ans = (ans * (power_mod(2, a, MOD) + 1)) % MOD
    return (ans - 1) % MOD

if __name__ == '__main__':
    N = int(input())
    A = read_ints()
    print(solve(N, A, 1000000007))
{% endhighlight %}


{% endsolution %}
