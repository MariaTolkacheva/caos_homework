#include <atomic>
#include <iostream>
#include <random>
#include <thread>
#include <vector>

enum {
  THREADS_COUNT = 4,
};

int main() {
  int N;
  std::cin >> N;
  std::vector<int> arr(N);
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> distrib(0, 99);

  for (auto &num : arr) {
    num = distrib(gen);
  }

  std::cout << "Array: ";
  for (size_t i = 0; i < arr.size(); ++i) {
    std::cout << arr[i] << ' ';
  }
  std::cout << '\n';

  std::vector<std::thread> threads;
  std::atomic<long> total_sum(0);
  size_t chunk_size = N / THREADS_COUNT;

  for (size_t i = 0; i < THREADS_COUNT; ++i) {
    size_t start = i * chunk_size;
    size_t end = (i == THREADS_COUNT - 1) ? N : (i + 1) * chunk_size;

    threads.emplace_back([&arr, start, end, &total_sum]() {
      long partial_sum = 0;
      for (size_t i = start; i < end; ++i) {
        partial_sum += arr[i];
      }
      total_sum += partial_sum;
    });
  }

  for (auto &t : threads) {
    t.join();
  }

  std::cout << "Total sum: " << total_sum << '\n';

  return 0;
}