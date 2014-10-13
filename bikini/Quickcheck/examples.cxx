#include <cmath>
#include <sstream>
#include <string>
#include <vector>

#include "../../lib/quickcheck/quickcheck/quickcheck.hh"

using namespace quickcheck

typedef int Elem
typedef std::vector<int> Vector
using std::string

template<class A> std::string toString(A a)
   std::stringstream ss
   ss << a
   return ss.str()

static void reverse(Vector& xs)
   std::reverse(xs.begin(), xs.end())

static bool isSorted(const Vector& xs)
   if (xs.empty()) return true
   int prev = xs[0]
   for (size_t i = 0; i < xs.size(); ++i)
      if (prev > xs[i]) return false
      else prev = xs[i]
   return true

static void insert(Elem x, Vector& xs)
   Vector::iterator pos = std::lower_bound(xs.begin(), xs.end(), x)
   xs.insert(pos, x)

// and now the exact code from the documentation
class PReverseCancelsReverse : public Property<Vector>
   bool holdsFor(const Vector& xs)
      Vector ys = xs
      reverse(ys)
      reverse(ys)
      return xs == ys
;

class PReverseCancelsReverse2 : public Property<Vector>
   bool holdsFor(const Vector& xs)
      Vector ys = xs
      reverse(ys)
      reverse(ys)
      return xs == ys
   bool isTrivialFor(const Vector& xs)
      return xs.size() < 2
;

class PReverseIsIdentity : public Property<Vector>
   bool holdsFor(const Vector& xs)
      Vector ys = xs
      reverse(ys)
      return xs == ys
;

class PInsertKeepsSorted : public Property<Elem, Vector>
   bool holdsFor(const Elem& x, const Vector& xs)
      Vector ys = xs
      insert(x, ys)
      return isSorted(ys)
;

class PInsertKeepsSorted2 : public Property<Elem, Vector>
   bool holdsFor(const Elem& x, const Vector& xs)
      Vector ys = xs
      insert(x, ys)
      return isSorted(ys)
   bool accepts(const Elem&, const Vector& xs)
      return isSorted(xs)
;

class PInsertKeepsSorted3 : public Property<Elem, Vector>
   bool holdsFor(const Elem& x, const Vector& xs)
      Vector ys = xs
      insert(x, ys)
      return isSorted(ys)
   bool accepts(const Elem&, const Vector& xs)
      return isSorted(xs)
   const string classify(const Elem& x, const Vector& xs)
      if (xs.empty())   return "in empty"
      if (x < xs[0])    return "at head"
      if (x > xs.back())return "at end"
      return "inside"
;

class PInsertKeepsSorted4 : public Property<Elem, Vector>
   bool holdsFor(const Elem& x, const Vector& xs)
      Vector ys = xs
      insert(x, ys)
      return isSorted(ys)
   bool accepts(const Elem&, const Vector& xs)
      return isSorted(xs)
   const string classify(const Elem& x, const Vector& xs)
      string s = toString(xs.size())
      if (xs.empty() || x <= xs[0])                     s += ", at head"
      if (xs.empty() || x >= xs.back())                 s += ", at end"
      if (!xs.empty() && x >= xs[0] && x <= xs.back())  s += ", inside"
      return s
;

class PInsertKeepsSorted5 : public Property<Elem, Vector>
   bool holdsFor(const Elem& x, const Vector& xs)
      Vector ys = xs
      insert(x, ys)
      return isSorted(ys)
   const string classify(const Elem& x, const Vector& xs)
      string s = toString(xs.size())
      if (xs.empty() || x <= xs[0])                     s += ", at head"
      if (xs.empty() || x >= xs.back())                 s += ", at end"
      if (!xs.empty() && x >= xs[0] && x <= xs.back())  s += ", inside"
      return s
   void generateInput(size_t n, Elem& x, Vector& xs)
      generate(n, x)
      generate(n, xs)
      sort(xs.begin(), xs.end())
;

struct Point
   int x
   int y
;

void generate(size_t n, Point& out)
void generate(size_t n, Point& out)
   generate(n, out.x)
   generate(n, out.y)

static int getTheAnswer(int i)
   while (i < 0);
   return 42

class PBottom : public Property<int>
   bool holdsFor(const int& i)
      return getTheAnswer(i) == 42
;

static unsigned iterativeSquare(unsigned n)
    unsigned res = 0
    for (unsigned i = 0; i < n; ++i)
        res += n
    return res

class PSquareDivisibleByRoot : public Property<unsigned>
   bool holdsFor(const unsigned& i)
      return unsigned(sqrt(iterativeSquare(i))) == i
;

int main()
   PReverseCancelsReverse revRev
   revRev.check()
   revRev.check(300)
   
   PReverseIsIdentity revId
   revId.check()
   
   PInsertKeepsSorted insertKeepsSorted
   insertKeepsSorted.check()
   
   PInsertKeepsSorted2 insertKeepsSorted2
   insertKeepsSorted2.check()
   insertKeepsSorted2.check(100, 2000)
   
   PReverseCancelsReverse2 revRev2
   revRev2.check()
   
   PInsertKeepsSorted3 insertKeepsSorted3
   insertKeepsSorted3.check(100, 2000)
   
   PInsertKeepsSorted4 insertKeepsSorted4
   insertKeepsSorted4.check(100, 2000)
   
   PInsertKeepsSorted5 insertKeepsSorted5
   insertKeepsSorted5.check()
   
   PSquareDivisibleByRoot squareDivisibleByRoot
   squareDivisibleByRoot.check()
   squareDivisibleByRoot.addFixed(std::numeric_limits<unsigned>::max())
   squareDivisibleByRoot.check()
   
   check<PReverseCancelsReverse>("that reverse cancels reverse")
   check<PReverseCancelsReverse>("that reverse cancels reverse", 200)
   check<PReverseCancelsReverse>("that reverse cancels reverse", 200, 600)
   check<PReverseIsIdentity>("that reverse is identity")
   
   std::cout \
      << "!!! Following check will loop until interrupted (press Ctrl-C)..." \
      << std::endl << std::endl;
   check<PBottom>("this property is stupid", 100, 0, true)
   
   return 0
