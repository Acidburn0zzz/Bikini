#include "gc.hpp"

#include <iostream>
using namespace std

//delete all objects
void gc_object_collection::delete_objects()
    while (!m_objects.empty())
        delete m_objects.back()

//collects garbage, using the mark & sweep algorithm
void gc::collect()
    gc_object_collection_ptr reachable{std::make_shared<gc_object_collection>()}
    _scan(*get_root_ptrs(), *get_objects().get(), *reachable.get())
    get_objects()->delete_objects()
    std::swap(get_objects(), reachable)

//scan ptrs
void gc::_scan(gc_ptr_collection &ptrs, gc_object_collection &old, gc_object_collection &reached)
    for(gc_ptr_base *ptr : ptrs.m_objects)
        if (ptr->m_object && ptr->m_object->m_collection == &old)
            old.remove(ptr->m_object)
            reached.add(ptr->m_object)
            _scan(ptr->m_object->m_member_ptrs, old, reached)
