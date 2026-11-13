#ifndef TEST_INTEROP_CXX_TEMPLATES_INPUTS_CLASS_TEMPLATE_MEMBER_TYPEDEF_SUGAR_H
#define TEST_INTEROP_CXX_TEMPLATES_INPUTS_CLASS_TEMPLATE_MEMBER_TYPEDEF_SUGAR_H

#include <stddef.h>

// Clang canonicalizes the template arguments of a class template
// specialization, so inside GiveNUMBER<size_t>, NUMBER is `unsigned long`
// rather than `size_t`. size_t is imported as Int, but unsigned long is
// imported as UInt, so we try to recover the size_t sugar from the use site.

template <typename T>
struct GiveNUMBER {
  typedef T NUMBER;
  using ConstNUMBER = const T;
};

struct Good {
  typedef size_t NUMBER;
  static size_t takeNUMBER(NUMBER x) { return x; }
};

struct Bad : public GiveNUMBER<size_t> {
  static size_t takeSizeT(size_t x) { return x; }
  static size_t takeNUMBER(NUMBER x) { return x; }
  static NUMBER returnNUMBER() { return 42; }
  static size_t takeConstRef(const NUMBER &x) { return x; }
  static size_t takePtr(NUMBER *x) { return *x; }
  static size_t takeConstNUMBER(ConstNUMBER x) { return x; }
  NUMBER field = 7;
};

inline size_t takeQualified(GiveNUMBER<size_t>::NUMBER x) { return x; }
inline size_t takeViaDerived(Bad::NUMBER x) { return x; }

using GiveSizeT = GiveNUMBER<size_t>;
inline size_t takeViaAlias(GiveSizeT::NUMBER x) { return x; }

struct Mid : GiveNUMBER<size_t> {};
struct Deep : Mid {
  static size_t take(NUMBER x) { return x; }
};

template <typename U>
using GiveNUMBERAlias = GiveNUMBER<U>;
struct ViaAliasTemplate : GiveNUMBERAlias<size_t> {
  static size_t take(NUMBER x) { return x; }
};

template <typename A, typename B>
struct Two {
  typedef A First;
  typedef B Second;
};
inline size_t takeSecond(Two<int, size_t>::Second x) { return x; }

// Written with the canonical type: nothing to recover, stays UInt.
struct Unsigned : GiveNUMBER<__SIZE_TYPE__> {
  static __SIZE_TYPE__ take(NUMBER x) { return x; }
};

// Partial specializations: template parameter indices do not line up with the
// written template arguments, so we do not try to resugar.
template <typename T> struct PartialGive;
template <typename T> struct PartialGive<T *> { typedef T NUMBER; };
inline void takePartial(PartialGive<size_t *>::NUMBER x) {}

// Members of the specialization itself have no use-site sugar to recover.
template <typename T>
struct Self {
  typedef T NUMBER;
  static T take(NUMBER x) { return x; }
};
using SelfSizeT = Self<size_t>;

#endif // TEST_INTEROP_CXX_TEMPLATES_INPUTS_CLASS_TEMPLATE_MEMBER_TYPEDEF_SUGAR_H
